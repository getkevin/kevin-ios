//
//  KevinPaymentConfirmationViewModel.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

internal class KevinPaymentConfirmationViewModel : KevinViewModel<KevinPaymentConfirmationState, KevinPaymentConfirmationIntent> {
    
    private let bankPaymentUrl = "https://psd2.kevin.eu/login/%@/%@/preview?lang=%@"
    private let bankPaymentAuthenticatedUrl = "https://psd2.kevin.eu/payments/%@/processing?lang=%@"
    private let cardPaymentUrl = "https://psd2.kevin.eu/card-details/%@?lang=%@"
    
    private let lockQueue = DispatchQueue(label: String(describing: KevinPaymentConfirmationViewModel.self), attributes: [])
    private var flowHasBeenProcessed = false
    
    override func offer(intent: KevinPaymentConfirmationIntent) {
        if let intent = intent as? KevinPaymentConfirmationIntent.Initialize {
            initialize(intent.configuration)
        }
        if let intent = intent as? KevinPaymentConfirmationIntent.HandlePaymentCompleted {
            notifyPaymentCompletion(callbackUrl: intent.url, error: intent.error)
        }
    }
    
    private func initialize(_ configuration: KevinPaymentConfirmationConfiguration) {
        var confirmationUrl: URL!
        if configuration.paymentType == .card {
            confirmationUrl = URL(string: String(format: cardPaymentUrl, configuration.paymentId, Kevin.shared.locale.identifier.lowercased()))!
        } else if configuration.paymentType == .bank {
            if configuration.skipAuthentication {
                confirmationUrl = URL(string: String(format: bankPaymentAuthenticatedUrl, configuration.paymentId, Kevin.shared.locale.identifier.lowercased()))!
            } else {
                confirmationUrl = URL(string: String(format: bankPaymentUrl, configuration.paymentId, configuration.selectedBank!, Kevin.shared.locale.identifier.lowercased()))!
            }
        }
        onStateChanged(KevinPaymentConfirmationState(url: confirmationUrl))
    }
    
    private func notifyPaymentCompletion(callbackUrl: URL?, error: Error?) {
        lockQueue.sync {
            guard !flowHasBeenProcessed else {
                return
            }
            if let error = error {
                KevinPaymentSession.shared.notifyPaymentCancelation(error: error)
                return
            }
            guard let statusGroup = callbackUrl?["statusGroup"] else {
                KevinPaymentSession.shared.notifyPaymentCancelation(error: KevinError(description: "Payment was canceled!"))
                return
            }
            if statusGroup == "completed" {
                if let paymentId = callbackUrl?["paymentId"] {
                    KevinPaymentSession.shared.notifyPaymentCompletion(paymentId: paymentId)
                }
            } else {
                KevinPaymentSession.shared.notifyPaymentCancelation(error: KevinError(description: "Payment was canceled!"))
            }
            flowHasBeenProcessed = true
        }
    }
}
