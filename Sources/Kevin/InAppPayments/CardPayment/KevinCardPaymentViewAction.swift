//
//  KevinCardPaymentViewAction.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 08/03/2022.
//  Copyright © 2022 kevin.. All rights reserved.
//

import Foundation

internal class KevinCardPaymentViewAction: IKevinIntent {
    
    internal class ShowFieldValidations: KevinCardPaymentIntent {
        let cardholderNameValidation: KevinValidationResult
        let cardNumberValidation: KevinValidationResult
        let expiryDateValidation: KevinValidationResult
        let cvvValidation: KevinValidationResult

        init(
            cardholderNameValidation: KevinValidationResult,
            cardNumberValidation: KevinValidationResult,
            expiryDateValidation: KevinValidationResult,
            cvvValidation: KevinValidationResult
        ) {
            self.cardholderNameValidation = cardholderNameValidation
            self.cardNumberValidation = cardNumberValidation
            self.expiryDateValidation = expiryDateValidation
            self.cvvValidation = cvvValidation
        }
    }

    internal class SubmitCardForm: KevinCardPaymentIntent {
        let cardholderName: String
        let cardNumber: String
        let expiryDate: String
        let cvv: String

        init(
            cardholderName: String,
            cardNumber: String,
            expiryDate: String,
            cvv: String
        ) {
            self.cardholderName = cardholderName
            self.cardNumber = cardNumber
            self.expiryDate = expiryDate
            self.cvv = cvv
        }
    }
    
    internal class SubmitUserRedirect: KevinCardPaymentIntent {
        let shouldRedirect: Bool

        init(shouldRedirect: Bool) {
            self.shouldRedirect = shouldRedirect
        }
    }
}
