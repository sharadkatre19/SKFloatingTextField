//
//  ToastView.swift
//  SKFloatingTextField
//
//  Created by Sharad Katre on 27/02/19.
//  Copyright © 2019 Sharad Katre. All rights reserved.
//

import UIKit

protocol ToastMessageViewModel {
    
    func show(animated: Bool)
    func dismiss(animated: Bool)
    var backgroundView: UIView {get set}
    var containerView: UIView {get set}
}

extension ToastMessageViewModel where Self: UIView {
    
    func show(animated: Bool) {
        self.backgroundView.alpha = 0
        if var topController = UIApplication.shared.delegate?.window??.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            let subviewsList = topController.view.subviews
            for view in subviewsList where view is ToastMessageView {
                view.removeFromSuperview()
                break
            }
            topController.view.addSubview(self)
        }
        
        if animated {
            self.containerView.frame.origin.y = UIScreen.main.bounds.maxY
            UIView.animate(withDuration: 1.25, animations: {
                self.backgroundView.alpha = 1.0
                self.containerView.frame.origin.y = UIScreen.main.bounds.maxY - 200.0
            }, completion: { (_) in
                self.backgroundView.alpha = 1.0
            })
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
            
            self.backgroundView.alpha = 1.0
            UIView.animate(withDuration: 0.25, animations: {
                self.backgroundView.alpha = 0.0
                self.containerView.frame.origin.y = UIScreen.main.bounds.maxY
            }, completion: { (_) in
                self.backgroundView.alpha = 0.0
                self.removeFromSuperview()
            })
        }
        
        
    }
    
    func dismiss(animated: Bool) {
        if animated {
            self.backgroundView.alpha = 1.0
            //            self.containerView.transform = .identity
            UIView.animate(withDuration: 0.25, animations: {
                self.backgroundView.alpha = 0.0
                self.containerView.frame.origin.y = UIScreen.main.bounds.maxY
            }, completion: { (_) in
                self.backgroundView.alpha = 0.0
                self.removeFromSuperview()
            })
        } else {
            self.backgroundView.alpha = 0.0
            self.removeFromSuperview()
        }
    }
}


class ToastMessageView: UIView, ToastMessageViewModel {
    
    internal lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.backgroundColor = .green
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    internal lazy var backgroundView: UIView = {
        let view = UIView()
        view.frame = frame
        view.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.0)
        return view
    }()
    
    internal lazy var containerView: UIView = {
        let view = UIView()
        view.frame = frame
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .red
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(_ message: String) {
        self.init(frame: UIScreen.main.bounds)
        self.setUpUI(message)
        self.show(animated: true)
    }
    
    func setUpUI(_ message: String) {
        setupBackgroundView()
        setupContainerView()
        prepareMessageLabel()
        messageLabel.text = message
    }
    
    private func prepareMessageLabel() {
        containerView.addSubview(messageLabel)
        
        messageLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16.0).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16.0).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16.0).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16.0).isActive = true
    }
    
    private func setupBackgroundView() {
        addSubview(backgroundView)
    }
    
    private func setupContainerView() {
        backgroundView.addSubview(containerView)
        if #available(iOS 11.0, *) {
            containerView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: 0.0).isActive = true
        } else {
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0).isActive = true
        }
        containerView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0.0).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0.0).isActive = true
        containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120.0)
    }
    
}
