//
//  KevinTextField.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 03/03/2022.
//  Copyright © 2021 kevin.. All rights reserved.
//

import UIKit

class KevinTextField: UITextField {
    var textInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    private let defaultPlaceholderColor = UIColor(red: 199/255, green: 199/255, blue: 205/255, alpha: 1)

    override var placeholder: String? {
        didSet {
            self.attributedPlaceholder = NSAttributedString(
                string: placeholder ?? "",
                attributes: [NSAttributedString.Key.foregroundColor: placeholderColor ?? defaultPlaceholderColor]
            )
        }
    }

    var placeholderColor: UIColor? {
        didSet {
            self.attributedPlaceholder = NSAttributedString(
                string: self.placeholder ?? "",
                attributes: [NSAttributedString.Key.foregroundColor: placeholderColor ?? defaultPlaceholderColor]
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
