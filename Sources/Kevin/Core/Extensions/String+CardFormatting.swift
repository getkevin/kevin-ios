//
//  String+CardFormatting.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 04/03/2022.
//  Copyright © 2022 kevin.. All rights reserved.
//

import Foundation

extension String {

    subscript (index: Int) -> Character {
        let charIndex = self.index(self.startIndex, offsetBy: index)
        return self[charIndex]
    }

    subscript (range: Range<Int>) -> Substring {
        let startIndex = self.index(self.startIndex, offsetBy: range.startIndex)
        let stopIndex = self.index(self.startIndex, offsetBy: range.startIndex + range.count)
        return self[startIndex..<stopIndex]
    }

    var isNumeric: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    func removeNonNumericCharacters() -> String {
        let filteredParts = self.components(separatedBy: CharacterSet.decimalDigits.inverted)
        return filteredParts.joined(separator: "")
    }
    
    func prefixString(_ maxLength: Int) -> String {
        return String(self.prefix(maxLength))
    }
    
    func suffixString(_ maxLength: Int) -> String {
        return String(self.suffix(maxLength))
    }

    func formatAsCardNumber() -> String {
        guard self.count > 4 else {
            return self
        }
        
        let head = String(self.prefix(4))
        let tail = String(self.suffix(self.count - 4))
        
        return "\(head) \(tail.formatAsCardNumber())"
    }
    
    func formatAsExpiryDate() -> String {
        guard self.count > 2 else {
            return self
        }
        
        let head = String(self.prefix(2))
        let tail = String(self.suffix(self.count - 2))
        
        return "\(head)/\(tail.formatAsExpiryDate())"
    }
    
    func getCurrencySymbol() -> String? {
        let locale = NSLocale(localeIdentifier: self)
        if locale.displayName(forKey: .currencySymbol, value: self) == self {
            let newlocale = NSLocale(localeIdentifier: self.dropLast() + "_en")
            return newlocale.displayName(forKey: .currencySymbol, value: self)
        }
        return locale.displayName(forKey: .currencySymbol, value: self)
    }
}
