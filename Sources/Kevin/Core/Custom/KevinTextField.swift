//
//  KevinTextField.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 03/03/2022.
//  Copyright © 2021 kevin.. All rights reserved.
//

import UIKit

class KevinErrorTextField: UIView {
    
    let textField = KevinTextField()
    let errorLabel = UILabel()
    
    var borderColor = UIColor.red
    
    private var textFieldBottomConstraint: NSLayoutConstraint?
    private var labelTopConstraint: NSLayoutConstraint?
    
    private var preErrorTextFieldBackgroundColor: UIColor?
    private var preErrorTextFieldBorderColor: CGColor?

    private let animationDuration: CGFloat = 0.25
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public convenience init() {
        self.init(frame: .zero)
    }

    private func commonInit() {
        addSubview(textField)
        textField.layer.zPosition = 2
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        textField.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textFieldBottomConstraint = textField.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        textFieldBottomConstraint?.isActive = true
        textField.addTarget(self, action: #selector(textFieldTextChanged), for: .editingChanged)
        
        addSubview(errorLabel)
        errorLabel.layer.zPosition = 1
        errorLabel.text = ""
        errorLabel.numberOfLines = 0
        errorLabel.textColor = borderColor
        errorLabel.alpha = 0
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        errorLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        errorLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        labelTopConstraint = errorLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8)
        labelTopConstraint?.isActive = false
    }
    
    func setError(_ errorMessage: String?) {
        if let errorMessage = errorMessage {
            showError(errorMessage)
        } else {
            hideError()
        }
    }
    
    private func showError(_ errorMessage: String) {
        if preErrorTextFieldBackgroundColor == nil {
            preErrorTextFieldBackgroundColor = textField.backgroundColor
            preErrorTextFieldBorderColor = textField.layer.borderColor
        }
        
        errorLabel.text = errorMessage
        textFieldBottomConstraint?.isActive = false
        labelTopConstraint?.isActive = true
        
        UIView.animate(withDuration: animationDuration) {
            self.textField.layer.borderColor = self.borderColor.cgColor

            self.errorLabel.alpha = 1
            self.superview?.layoutIfNeeded()
        }
    }
    
    private func hideError() {
        
        labelTopConstraint?.isActive = false
        textFieldBottomConstraint?.isActive = true
        
        UIView.animate(withDuration: animationDuration) {
            if self.preErrorTextFieldBackgroundColor != nil {
                self.textField.backgroundColor = self.preErrorTextFieldBackgroundColor
                self.textField.layer.borderColor = self.preErrorTextFieldBorderColor
            }
            
            self.errorLabel.alpha = 0
            self.superview?.layoutIfNeeded()
        } completion: { _ in
            self.errorLabel.text = ""
            self.preErrorTextFieldBackgroundColor = nil
            self.preErrorTextFieldBorderColor = nil
        }
    }
    
    @objc fileprivate func textFieldTextChanged() {
        hideError()
    }
}

class KevinTextField: UITextField {
    var textInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    private let placeholderGray = UIColor(red: 199/255, green: 199/255, blue: 205/255, alpha: 1)

    override var placeholder: String? {
        didSet {
            self.attributedPlaceholder = NSAttributedString(
                string: placeholder ?? "",
                attributes: [NSAttributedString.Key.foregroundColor: placeholderColor ?? placeholderGray]
            )
        }
    }

    var placeholderColor: UIColor? {
        didSet {
            self.attributedPlaceholder = NSAttributedString(
                string: self.placeholder ?? "",
                attributes: [NSAttributedString.Key.foregroundColor: placeholderColor ?? placeholderGray]
            )
        }
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInset)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInset)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textInset)
    }
}
