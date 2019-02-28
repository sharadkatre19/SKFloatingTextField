//
//  SKFloatingTextField.swift
//  SKFloatingTextField
//
//  Created by Sharad Katre on 22/01/19.
//  Copyright © 2019 Sharad Katre. All rights reserved.
//

import Foundation
import UIKit

struct Tags {
    static let titleLabel = 1001
    static let separatorView = 1002
}

@IBDesignable
class SKFloatingTextField: UITextField {
    
    //MARK: - Properties
    private var separatorHeightConstraint: NSLayoutConstraint?
    private var topConstraint: NSLayoutConstraint?
    
    //MARK: - UI Components
    private lazy var titleLabel: UILabel! = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: (self.frame.height / 2), width: self.frame.width, height: (self.frame.height / 2))
        label.text = self.placeholder
        label.alpha = 0.5
        label.font = titleFont
        label.isHidden = true
        label.tag = Tags.titleLabel
        label.clipsToBounds = true
        return label
    }()
    
    private lazy var separatorView: UIView! = {
        let separatorView = UIView()
        separatorView.tag = Tags.separatorView
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = separatorColor
        separatorView.clipsToBounds = true
        return separatorView
    }()
    
    //MARK: - Responder handling
    @discardableResult
    override open func becomeFirstResponder() -> Bool {
        let result = super.becomeFirstResponder()
        updateSeparatorView(true)
        updateTitleLabel(true)
        return result
    }
    
    @discardableResult
    override open func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        updateSeparatorView(false)
        updateTitleLabel(false)
        return result
    }
    
    //
    //MARK: - TextField Editing or Selected
    //
    // Return Bool texfield is editing or selected
    open var editingOrSelected: Bool {
        return super.isEditing || super.isSelected
    }
    
    //
    //MARK: - Default Separator Color
    //
    @IBInspectable dynamic open var separatorColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
            updateSeparatorView(editingOrSelected)
        }
    }
    
    //
    //MARK: - Selected Separator Color
    //
    @IBInspectable dynamic open var selectedSeparatorColor: UIColor = UIColor.blue {
        didSet {
            setNeedsDisplay()
        }
    }
    
    //
    //MARK: - Default Separator Height
    //
    @IBInspectable dynamic open var separatorHeight: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
            updateSeparatorView(editingOrSelected)
        }
    }
    
    //
    //MARK: - Selected Separator Height
    //
    @IBInspectable dynamic open var selectedSeparatorHeight: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    //
    //MARK: - Placeholder Color
    //
    @IBInspectable dynamic open var placeholderColor: UIColor = UIColor.lightGray {
        didSet {
            setNeedsDisplay()
            updatePlaceholder()
        }
    }
    
    //
    //MARK: - Default Title Label Text Color
    //
    @IBInspectable dynamic open var titleColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    //
    //MARK: - Selected Title Label Text Color
    //
    @IBInspectable dynamic open var selectedTitleColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    //
    //MARK: - Title Label Font
    //
    @IBInspectable dynamic open var titleFont: UIFont = .systemFont(ofSize: 13) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable dynamic open var isTitleEnable: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }
    //
    //MARK: - Initialization
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareUI()
    }
    
    override func prepareForInterfaceBuilder() {
        prepareUI()
    }
    
    //
    //MARK: - Default UI Preparation
    //
    func prepareUI() {
        prepareDefaultTextFieldView()
        prepareTitleLabel()
        prepareBottomSeparatorView(separatorColor)
    }
    
    private func prepareDefaultTextFieldView() {
        self.borderStyle = .none
        self.backgroundColor = UIColor.clear
        self.clipsToBounds = true
    }
    
    private func prepareTitleLabel() {
        self.removeView(withTag: Tags.titleLabel)
        self.addSubview(titleLabel)
    }
    
    func prepareBottomSeparatorView(_ separatorColor: UIColor) {
        self.removeView(withTag: Tags.separatorView)
        self.addSubview(separatorView)
        
        topConstraint = separatorView.topAnchor.constraint(equalTo: self.bottomAnchor, constant: -separatorHeight)
        separatorHeightConstraint = separatorView.heightAnchor.constraint(equalToConstant: separatorHeight)
        
        NSLayoutConstraint.activate([
            topConstraint!,
            separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0),
            separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0),
            separatorHeightConstraint!
            ])
    }
    
    //
    //MARK: - Remove subview
    //
    // Removes subview if available for specified tag
    private func removeView(withTag tag: Int) {
        for view in self.subviews where view.tag == tag {
            view.removeFromSuperview()
        }
    }
    
    //
    //MARK: - Update Placeholder Color IB Designable
    //
    private func updatePlaceholder() {
        guard let placeHolder = placeholder else { return }
        attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
    }
    
    //
    //MARK: - Update Separator View IB Designable
    //
    private func updateSeparatorView(_ isSelected: Bool) {
        if isSelected {
            setNeedsDisplay()
            self.separatorView.backgroundColor = selectedSeparatorColor
            separatorHeightConstraint?.constant = selectedSeparatorHeight
            topConstraint?.constant = -selectedSeparatorHeight
        } else {
            setNeedsDisplay()
            self.separatorView.backgroundColor = separatorColor
            separatorHeightConstraint?.constant = separatorHeight
            topConstraint?.constant = -separatorHeight
        }
    }
    
    //
    //MARK: - Update Title Label IB Designable
    //
    private func updateTitleLabel(_ isSelected: Bool) {
        if isSelected {
            self.titleLabel.textColor = selectedTitleColor
            setNeedsDisplay()
        } else {
            self.titleLabel.textColor = titleColor
            setNeedsDisplay()
        }
    }
    
    // MARK: - TextField Rect Delegate Methods
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        if isTitleEnable {
            if (self.text?.count)! > 0 {
                self.titleLabel.isHidden = false
                UIView.animate(withDuration: 0.3, animations: {
                    self.titleLabel.frame.origin.y = 0
                }, completion: nil)
            } else {
                self.titleLabel.isHidden = true
                self.titleLabel.frame.origin.y = (self.frame.height / 2)
            }
            
            var rect = super.editingRect(forBounds: bounds)
            let rightRect = self.rightViewRect(forBounds: bounds)
            rect.size.width -= rightRect.size.width
            rect.origin.y += 10
            return rect
        } else {
            return bounds
        }
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        if isTitleEnable {
            var rect = super.editingRect(forBounds: bounds)
            let rightRect = self.rightViewRect(forBounds: bounds)
            rect.size.width -= rightRect.size.width
            rect.origin.y += 10
            return rect
        } else {
            return bounds
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        if isTitleEnable {
            var rect = super.editingRect(forBounds: bounds)
            let rightRect = self.rightViewRect(forBounds: bounds)
            rect.size.width -= rightRect.size.width
            rect.origin.y += 10
            return rect
        } else {
            return bounds
        }
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(cut(_:)) {
            return false
        }
        if action == #selector(copy(_:)) {
            return false
        }
        if action == #selector(paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
