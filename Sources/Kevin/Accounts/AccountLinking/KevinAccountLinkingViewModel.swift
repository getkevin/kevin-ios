//
//  KevinAccountLinkingViewModel.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

internal class KevinAccountLinkingViewModel : KevinViewModel<KevinAccountLinkingState, KevinAccountLinkingIntent> {
    
    private let bankLinkingUrl = "https://psd2.kevin.eu/login/%@/%@/preview"
    
    override func offer(intent: KevinAccountLinkingIntent) {
        if let intent = intent as? KevinAccountLinkingIntent.Initialize {
            initialize(intent.configuration)
        }
        if let intent = intent as? KevinAccountLinkingIntent.HandleLinkingCompleted {
            notifyLinkingCompletion(callbackUrl: intent.url, error: intent.error, configuration: intent.configuration)
        }
    }
    
    private func initialize(_ configuration: KevinAccountLinkingConfiguration) {
        onStateChanged(
            KevinAccountLinkingState(
                bankRedirectUrl: URL(string: String(format: bankLinkingUrl, configuration.state, configuration.selectedBankId))!
            )
        )
    }
    
    private func notifyLinkingCompletion(
        callbackUrl: URL,
        error: Error?,
        configuration: KevinAccountLinkingConfiguration
    ) {
        if let error = error {
            KevinAccountLinkingSession.shared.notifyAccountLinkingCancelation(error: error)
            return
        }
        guard let status = callbackUrl["status"] else {
            return
        }
        if status == "success" {
            if let code = callbackUrl["code"] {
                KevinAccountLinkingSession.shared.notifyAccountLinkingCompletion(
                    authorizationCode: code,
                    bankId: configuration.selectedBankId
                )
            } else {
                KevinAccountLinkingSession.shared.notifyAccountLinkingCancelation(
                    error: KevinError(description: "Account authorizationCode has not been returned!")
                )
            }
        } else {
            KevinAccountLinkingSession.shared.notifyAccountLinkingCancelation(
                error: KevinError(description: "Account linking was canceled!")
            )
        }
    }
}
