//
//  ViewController.swift
//  SKFloatingTextField
//
//  Created by Sharad Katre on 22/01/19.
//  Copyright © 2019 Sharad Katre. All rights reserved.
//

import UIKit

struct Message : Decodable {
    var key: String?
    var value: String?
}

class ViewController: UIViewController {

    @IBOutlet weak var skFloatingTextField: SKFloatingTextField!
    
    let words = ["India", "England", "Indoneshia", "Canada", "USA", "Australia", "Bangladesh", "Newzeland", "Pakistan", "India", "England", "Indoneshia", "Canada", "USA", "Australia", "Bangladesh", "Newzeland", "Pakistan"]
    
    let wordsIndexTitles = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    
    var wordsSection = [String]()
    var wordsDict = [String: [String]]()
    
    func generateWordsDict() {
        for word in words {
            let key = "\(word[word.startIndex])"
            let lower = key.uppercased()
            if var wordValue = wordsDict[lower] {
                wordValue.append(word)
                wordsDict[lower] = wordValue
            } else {
                wordsDict[lower] = [word]
            }
        }
        wordsSection = [String](wordsDict.keys)
        wordsSection = wordsSection.sorted()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        loadJson(filename: "selection")
//        skFloatingTextField.delegate = self
//
//        generateWordsDict()
//
//        let tableView = UITableView()
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.delegate = self
//        tableView.dataSource = self
//        self.view.addSubview(tableView)
//
//        tableView.topAnchor.constraint(equalTo: self.skFloatingTextField.bottomAnchor, constant: 16.0).isActive = true
//        tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0.0).isActive = true
//        tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0.0).isActive = true
//        tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0.0).isActive = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func loadJson(filename fileName: String?) -> [Message]? {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([Message].self, from: data)
                
                for data in jsonData {
                    
                    let text = "static let " + data.key! + " = \"\\u{" + data.value! + "}\""
                    print(text)
                    
                }
                return jsonData
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }

}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return wordsSection.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return wordsSection[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let wordKey = wordsSection[section]
        if let wordsValue = wordsDict[wordKey] {
            return wordsValue.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let wordsKey = wordsSection[indexPath.section]
        if let wordsValue = wordsDict[wordsKey.uppercased()], wordsValue.count != 0 {
            cell.textLabel?.text = wordsValue[indexPath.row]
        }
        return cell
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return wordsIndexTitles
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        guard let index = wordsSection.firstIndex(of: title) else { return -1}
        return index
    }
}
