//
//  KevinCardPaymentValidator.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 04/03/2022.
//  Copyright © 2021 kevin.. All rights reserved.

import Foundation

class KevinCardPaymentValidator {
    @discardableResult
    static func isValidCardholderName(_ name: String) -> KevinValidationResult {
        guard !name.isEmpty else {
            return .invalid(message: "error_no_cardholder_name".localized(for: Kevin.shared.locale.identifier))
        }
        return .valid
    }
    
    @discardableResult
    static func isValidCardNumber(_ cardNumber: String) -> KevinValidationResult {
        guard !cardNumber.isEmpty else {
            return .invalid(message: "error_no_card_number".localized(for: Kevin.shared.locale.identifier))
        }
        
        let numericOnlyCardNumber = cardNumber.removeNonNumericCharacters()
        
        guard numericOnlyCardNumber.count == 16 else {
            return .invalid(message: "error_invalid_card_number".localized(for: Kevin.shared.locale.identifier))
        }
        
        guard isValidLuhn(numericOnlyCardNumber) else {
            return .invalid(message: "error_invalid_card_number".localized(for: Kevin.shared.locale.identifier))
        }

        return .valid
    }

    @discardableResult
    static func isValidExpiryDate(_ expiryDate: String) -> KevinValidationResult {
        guard !expiryDate.isEmpty else {
            return .invalid(message: "error_no_expiry_date".localized(for: Kevin.shared.locale.identifier))
        }

        let numericOnlyExpiryDate = expiryDate.removeNonNumericCharacters()

        guard numericOnlyExpiryDate.count == 4 else {
            return .invalid(message: "error_invalid_expiry_date".localized(for: Kevin.shared.locale.identifier))
        }
        
        let month = numericOnlyExpiryDate.prefixString(2)
        guard Int(month)! <= 12 else {
            return .invalid(message: "error_invalid_expiry_date".localized(for: Kevin.shared.locale.identifier))
        }
        
        guard !isExpired(numericOnlyExpiryDate) else {
            return .invalid(message: "error_card_expired".localized(for: Kevin.shared.locale.identifier))
        }

        return .valid
    }

    @discardableResult
    static func isValidCvv(_ cvv: String) -> KevinValidationResult {
        guard !cvv.isEmpty else {
            return .invalid(message: "error_no_cvv".localized(for: Kevin.shared.locale.identifier))
        }

        let numericOnlyCvv = cvv.removeNonNumericCharacters()

        guard numericOnlyCvv.count == 3 else {
            return .invalid(message: "error_invalid_cvv".localized(for: Kevin.shared.locale.identifier))
        }

        return .valid
    }    
    
    private static func isValidLuhn(_ cardNumber: String) -> Bool {
        var isOdd = true
        var sum = 0
        
        for index in stride(from: cardNumber.count - 1, to: -1, by: -1) {
            let c = cardNumber[index]
            
            guard var digitInteger = c.wholeNumberValue else {
                return false
            }

            isOdd = !isOdd

            if (isOdd) {
                digitInteger *= 2
            }

            if (digitInteger > 9) {
                digitInteger -= 9
            }

            sum += digitInteger
        }

        return sum % 10 == 0
    }

    private static func isExpired(_ expiryDate: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMyy"
        let enteredDate = dateFormatter.date(from: expiryDate)!
        let endOfMonth = Calendar.current.date(byAdding: .month, value: 1, to: enteredDate)!
        let now = Date()
        return endOfMonth < now
    }
}
