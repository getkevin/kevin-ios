//
//  KevinPaymentConfirmationViewModel.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation
import UIKit

internal class KevinPaymentConfirmationViewModel : KevinViewModel<KevinPaymentConfirmationState, KevinPaymentConfirmationIntent> {
    
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
            confirmationUrl = appendUrlParameters(urlString: String(
                format: KevinApiPaths.cardPaymentUrl,
                configuration.paymentId,
                Kevin.shared.locale.identifier.lowercased()
            ))
        } else if configuration.paymentType == .bank {
            if configuration.skipAuthentication {
                confirmationUrl = appendUrlParameters(urlString: String(
                    format: KevinApiPaths.bankPaymentAuthenticatedUrl,
                    configuration.paymentId,
                    Kevin.shared.locale.identifier.lowercased()
                ))
            } else {
                confirmationUrl = appendUrlParameters(urlString: String(
                    format: KevinApiPaths.bankPaymentUrl,
                    configuration.paymentId,
                    configuration.selectedBank!,
                    Kevin.shared.locale.identifier.lowercased()
                ))
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
            guard let statusGroup = callbackUrl?["statusGroup"], let status = KevinPaymentStatus(rawValue: statusGroup) else {
                KevinPaymentSession.shared.notifyPaymentCancelation(error: KevinError(description: "Payment was canceled!"))
                return
            }
            if status == .completed || status == .pending {
                if let paymentId = callbackUrl?["paymentId"] {
                    KevinPaymentSession.shared.notifyPaymentCompletion(
                        paymentId: paymentId,
                        status: status
                    )
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
