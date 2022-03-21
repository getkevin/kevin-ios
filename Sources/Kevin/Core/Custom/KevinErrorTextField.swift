//
//  KevinErrorTextField.swift
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
    
    private var previousErrorTextFieldBackgroundColor: UIColor?
    private var previousErrorTextFieldBorderColor: CGColor?

    private let animationDuration: CGFloat = 0.25
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    public convenience init() {
        self.init(frame: .zero)
    }

    private func initialize() {
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
        if previousErrorTextFieldBackgroundColor == nil {
            previousErrorTextFieldBackgroundColor = textField.backgroundColor
            previousErrorTextFieldBorderColor = textField.layer.borderColor
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
            if self.previousErrorTextFieldBackgroundColor != nil {
                self.textField.backgroundColor = self.previousErrorTextFieldBackgroundColor
                self.textField.layer.borderColor = self.previousErrorTextFieldBorderColor
            }
            self.errorLabel.alpha = 0
            self.superview?.layoutIfNeeded()
        } completion: { _ in
            self.errorLabel.text = ""
            self.previousErrorTextFieldBackgroundColor = nil
            self.previousErrorTextFieldBorderColor = nil
        }
    }
    
    @objc fileprivate func textFieldTextChanged() {
        hideError()
    }
}
