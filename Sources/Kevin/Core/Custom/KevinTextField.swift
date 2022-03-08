//
//  KevinTextField.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 03/03/2022.
//  Copyright © 2021 kevin.. All rights reserved.
//

import UIKit

class KevinTextField: UITextField {
    
    private let placeholderGray = UIColor(red: 199/255, green: 199/255, blue: 205/255, alpha: 1)
    private let padding = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 5)

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
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    func showError(_ errorMessage: String? = nil) {
        guard let errorMessage = errorMessage else {
            hideError()
            return
        }
        
        if errorMessage.count < 1 {
            hideError()
            return
        }

        self.backgroundColor = Kevin.shared.theme.cardPaymentStyle.textFieldErrorColor
        self.layer.borderColor = Kevin.shared.theme.cardPaymentStyle.textFieldBorderErrorColor.cgColor
        
        shake()
    }
    
    func hideError() {
        self.backgroundColor = Kevin.shared.theme.cardPaymentStyle.textFieldBackgroundColor
        self.layer.borderColor = Kevin.shared.theme.cardPaymentStyle.textFieldBorderColor.cgColor
    }
    
    func shake() {
        let animation = CAKeyframeAnimation.init(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6;
        animation.values = [-20, 20, -15, 15, -10, 10, -5, 5, 0];
        self.layer.add(animation, forKey: "shake")
    }
}
