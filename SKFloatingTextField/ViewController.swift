//
//  ViewController.swift
//  SKFloatingTextField
//
//  Created by Sharad Katre on 22/01/19.
//  Copyright © 2019 Sharad Katre. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var skFloatingTextField: SKFloatingTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        skFloatingTextField.delegate = self
        ToastMessageView("Hello I am ToastHello I am ToastHello I am ToastHello I am ToastHello I am ToastHello I am Toast")
//        tostMessageView.show(animated: true)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
