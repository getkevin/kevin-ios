//
//  KevinPaymentConfirmationViewModel.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

internal class KevinPaymentConfirmationViewModel : KevinViewModel<KevinPaymentConfirmationState, KevinPaymentConfirmationIntent> {
    
    private let bankPaymentUrl = "https://psd2.getkevin.eu/login/%@/%@/preview"
    private let cardPaymentUrl = "https://psd2.getkevin.eu/card-details/%@"
    
    override func offer(intent: KevinPaymentConfirmationIntent) {
        if let intent = intent as? KevinPaymentConfirmationIntent.Initialize {
            initialize(intent.configuration)
        }
        if let intent = intent as? KevinPaymentConfirmationIntent.HandlePaymentCompleted {
            notifyPaymentCompletion(callbackUrl: intent.url, error: intent.error)
        }
    }
    
    private func initialize(_ configuration: KevinPaymentConfirmationConfiguration) {
        if configuration.paymentType == .card {
            onStateChanged(
                KevinPaymentConfirmationState(
                    url: URL(string: String(format: cardPaymentUrl, configuration.paymentId))!
                )
            )
        } else if configuration.paymentType == .bank {
            onStateChanged(
                KevinPaymentConfirmationState(
                    url: URL(string: String(format: bankPaymentUrl, configuration.paymentId, configuration.selectedBank!))!
                )
            )
        }
    }
    
    private func notifyPaymentCompletion(callbackUrl: URL, error: Error?) {
        if let error = error {
            KevinPaymentSession.shared.notifyPaymentCancelation(error: error)
            return
        }
        guard let statusGroup = callbackUrl["statusGroup"] else {
            return
        }
        if statusGroup == "failed" {
            KevinPaymentSession.shared.notifyPaymentCancelation(error: KevinError(description: "Payment was canceled!"))
        } else if statusGroup == "completed" {
            if let paymentId = callbackUrl["paymentId"] {
                KevinPaymentSession.shared.notifyPaymentCompletion(paymentId: paymentId)
            }
        }
    }
}
