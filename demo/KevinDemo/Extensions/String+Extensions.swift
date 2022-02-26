//
//  String+Extensions.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 21/02/2022.
//

import Foundation

extension String {
    
    func isValidEmail() -> Bool {
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }

    func toCurrencyFormat() -> String {
        let decimalSeparator = Locale.current.decimalSeparator!
        let parts = self.split(separator: ".")
        if parts.count == 1 {
            if self.hasSuffix(decimalSeparator) {
                return self.replacingOccurrences(of: decimalSeparator, with: ".")
            }
            return self
        } else if parts.count == 2 {
            return "\(parts.first!).\(parts.last!.prefix(2))"
        }
        return ""
    }
}
