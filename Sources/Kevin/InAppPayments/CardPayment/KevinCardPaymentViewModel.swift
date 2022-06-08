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
    
    private var configuration: KevinCardPaymentConfiguration?
    
    private let lockQueue = DispatchQueue(label: String(describing: KevinCardPaymentViewModel.self), attributes: [])
    private var flowHasBeenProcessed = false

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
        } else if let _ = intent as? KevinCardPaymentIntent.HandlePageStartedLoading {
            handlePageStartedLoading()
        } else if let _ = intent as? KevinCardPaymentIntent.HandlePageFinishedLoading {
            handlePageFinishedLoading()
        } else if let intent = intent as? KevinCardPaymentIntent.HandleCardPaymentEvent {
            handleEvent(event: intent.event)
        } else if let intent = intent as? KevinCardPaymentIntent.HandlePaymentResult {
            handlePaymentResult(callbackUrl: intent.url, error: intent.error)
        } else if let intent = intent as? KevinCardPaymentIntent.HandleUserSoftRedirect {
            handleUserSoftRedirect(shouldRedirect: intent.shouldRedirect)
        }
    }
    
    private func initialize(_ configuration: KevinCardPaymentConfiguration) {
        state = KevinCardPaymentState()
        
        self.configuration = configuration
        
        let confirmationUrl = appendUrlParameters(
            urlString: String(format: KevinApiPaths.cardPaymentUrl, configuration.paymentId, Kevin.shared.locale.identifier.lowercased())
        )
                
        KevinPaymentsApiClient.shared.getCardPaymentInfo(
            paymentId: configuration.paymentId
        ) { [weak self] response, error in
            if let response = response {
                let amountString = String(format: "%@ %.2f", response.currencyCode.getCurrencySymbol() ?? "", response.amount)
                self?.state?.amount = amountString
            }
        }

        state?.url = confirmationUrl
    }
    
    private func handlePageStartedLoading() {
        state?.isContinueEnabled = false
    }
    
    private func handlePageFinishedLoading() {
        state?.isContinueEnabled = true
    }
    
    private func handleEvent(event: KevinCardPaymentEvent) {
        switch event {
        case .softRedirect(let cardNumber):
            guard let configuration = configuration else {
                return
            }
            
            KevinPaymentsApiClient.shared.getBankFromCardNumber(
                paymentId: configuration.paymentId,
                cardNumberPart: cardNumber
            ) { [weak self] response, error in
                if let response = response {
                    let bankName = response.name
                    
                    self?.viewAction(KevinCardPaymentViewAction.ShowUserRedirectPrompt(bankName: bankName))

                    self?.state?.loadingState = .notLoading
                }
            }
            break
        case .hardRedirect:
            state?.isContinueEnabled = false
            state?.showCardDetails = false
            state?.loadingState = .notLoading
            break
        case .submittingCardData:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.state?.isContinueEnabled = false
                self.state?.showCardDetails = false
                self.state?.loadingState = .notLoading
            }
            break
        }
    }
    
    private func handleUserSoftRedirect(shouldRedirect: Bool) {
        viewAction(KevinCardPaymentViewAction.SubmitUserRedirect(shouldRedirect: shouldRedirect))
        if shouldRedirect {
            state?.isContinueEnabled = false
            state?.showCardDetails = false
        }
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
            state?.isContinueEnabled = false
            state?.loadingState = .loading
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
    
    private func handlePaymentResult(callbackUrl: URL, error: Error?) {
        lockQueue.sync {
            guard !flowHasBeenProcessed else {
                return
            }
            if let error = error {
                KevinPaymentSession.shared.notifyPaymentCancelation(error: error)
                return
            }
            guard let statusGroup = callbackUrl["statusGroup"] else {
                KevinPaymentSession.shared.notifyPaymentCancelation(error: KevinError(description: "Payment was canceled!"))
                return
            }
            if statusGroup == "completed" {
                if let paymentId = callbackUrl["paymentId"] {
                    KevinPaymentSession.shared.notifyPaymentCompletion(paymentId: paymentId)
                }
            } else {
                KevinPaymentSession.shared.notifyPaymentCancelation(error: KevinError(description: "Payment was canceled!"))
            }
            flowHasBeenProcessed = true
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
