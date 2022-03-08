//
//  KevinCardPaymentViewModel.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 02/03/2022.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation
import UIKit

internal class KevinCardPaymentViewModel : KevinViewModel<KevinCardPaymentState, KevinCardPaymentIntent> {

    var viewAction: (IKevinIntent)->() = { action in }

    private let cardPaymentUrl = "https://psd2.kevin.eu/card-details/%@"

    override func offer(intent: KevinCardPaymentIntent) {
        if let intent = intent as? KevinCardPaymentIntent.Initialize {
            initialize(intent.configuration)
        } else if let intent = intent as? KevinCardPaymentIntent.HandleOnContinueClicked {
            handleOnContinueClicked(
                intent.cardholderName,
                intent.cardNumber,
                intent.expiryDate,
                intent.cvv
            )
        }
    }
    
    func getSymbol(forCurrencyCode code: String) -> String? {
        let locale = NSLocale(localeIdentifier: code)
        if locale.displayName(forKey: .currencySymbol, value: code) == code {
            let newlocale = NSLocale(localeIdentifier: code.dropLast() + "_en")
            return newlocale.displayName(forKey: .currencySymbol, value: code)
        }
        return locale.displayName(forKey: .currencySymbol, value: code)
    }

    private func initialize(_ configuration: KevinCardPaymentConfiguration) {
        let confirmationUrl = appendUrlParameters(
            urlString: String(format: cardPaymentUrl, configuration.paymentId, Kevin.shared.locale.identifier.lowercased())
        )
        
        KevinCardPaymentApiClient.shared.getCardPaymentInfo(
            paymentId: configuration.paymentId
        ) { [weak self] response, error in
            if let response = response {
                let amountString = String(format: "%@ %.2f", self?.getSymbol(forCurrencyCode: response.currencyCode) ?? "", response.amount)

                self?.onStateChanged(
                    KevinCardPaymentState(
                        url: confirmationUrl,
                        amount: amountString
                    )
                )
            }
        }

        onStateChanged(KevinCardPaymentState(url: confirmationUrl, amount: nil))
    }
    
    private func handleOnContinueClicked(
        _ cardholderName: String,
        _ cardNumber: String,
        _ expiryDate: String,
        _ cvv: String
    ) {
        let isValidCardholderName = KevinCardPaymentValidator.isValidCardholderName(cardholderName)
        let isValidCardNumber = KevinCardPaymentValidator.isValidCardNumber(cardNumber)
        let isValidExpiryDate = KevinCardPaymentValidator.isValidExpiryDate(expiryDate)
        let isValidCvv = KevinCardPaymentValidator.isValidCvv(cvv)

        viewAction(
            KevinCardPaymentViewAction.ShowFieldValidations(
                cardholderNameValidation: isValidCardholderName,
                cardNumberValidation: isValidCardNumber,
                expiryDateValidation: isValidExpiryDate,
                cvvValidation: isValidCvv
            )
        )

        if isValidCardholderName.isValid &&
            isValidCardNumber.isValid &&
            isValidExpiryDate.isValid &&
            isValidCvv.isValid {
            viewAction(
                KevinCardPaymentViewAction.SubmitCardForm(
                    cardholderName: cardholderName,
                    cardNumber: cardNumber,
                    expiryDate: expiryDate,
                    cvv: cvv
                )
            )
        }
    }
    
    private func appendUrlParameters(urlString: String) -> URL {
        let customStyle = [
            "bc": Kevin.shared.theme.generalStyle.primaryBackgroundColor.hexString,
            "bsc": Kevin.shared.theme.generalStyle.primaryBackgroundColor.hexString,
            "hc": Kevin.shared.theme.generalStyle.primaryTextColor.hexString,
            "fc": Kevin.shared.theme.generalStyle.primaryTextColor.hexString,
            "bic": UIApplication.shared.isLightThemedInterface ? "default" : "white",
            "dbc": Kevin.shared.theme.mainButtonStyle.backgroundColor.hexString
        ]

        let jsonData = try! JSONEncoder().encode(customStyle)
        let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)!

        let queryItems = [
            URLQueryItem(name: "lang", value: Kevin.shared.locale.identifier.lowercased()),
            URLQueryItem(name: "cs", value: jsonString)
        ]
        var urlComponents = URLComponents(string: urlString)!
        urlComponents.queryItems = queryItems
        let result = urlComponents.url!
        
        return result
    }
}
