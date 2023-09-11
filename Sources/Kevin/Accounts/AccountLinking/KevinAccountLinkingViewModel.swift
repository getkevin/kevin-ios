//
//  KevinAccountLinkingViewModel.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation
import UIKit

internal class KevinAccountLinkingViewModel : KevinViewModel<KevinAccountLinkingState, KevinAccountLinkingIntent> {
    
    override func offer(intent: KevinAccountLinkingIntent) {
        if let intent = intent as? KevinAccountLinkingIntent.Initialize {
            initialize(intent.configuration)
        }
        if let intent = intent as? KevinAccountLinkingIntent.HandleLinkingCompleted {
            notifyLinkingCompletion(callbackUrl: intent.url, error: intent.error, configuration: intent.configuration)
        }
    }
    
    private func initialize(_ configuration: KevinAccountLinkingConfiguration) {
        let baseUrl = String(format: KevinApiPaths.bankLinkingUrl, configuration.state, configuration.selectedBankId!)
        
        onStateChanged(
            KevinAccountLinkingState(
                bankRedirectUrl: FrameCustomisationHelper.appendUrlParameters(urlString: baseUrl),
                accountLinkingType: configuration.linkingType
            )
        )
    }
    
    private func notifyLinkingCompletion(
        callbackUrl: URL?,
        error: Error?,
        configuration: KevinAccountLinkingConfiguration
    ) {
        if let error = error {
            KevinAccountLinkingSession.shared.notifyAccountLinkingCancelation(error: error)
            return
        }
        guard let status = callbackUrl?["status"] else {
            KevinAccountLinkingSession.shared.notifyAccountLinkingCancelation(
                error: KevinErrors.unknownLinkingStatus
            )
            return
        }
        if status == "success" {
            if let code = callbackUrl?["code"] {
                KevinAccountLinkingSession.shared.notifyAccountLinkingCompletion(
                    authorizationCode: code,
                    bankId: configuration.selectedBankId,
                    country: configuration.selectedCountry,
                    linkingType: configuration.linkingType
                )
            } else {
                KevinAccountLinkingSession.shared.notifyAccountLinkingCancelation(
                    error: KevinErrors.accountAuthCodeMissing
                )
            }
        } else {
            KevinAccountLinkingSession.shared.notifyAccountLinkingCancelation(
                error: KevinErrors.linkingCanceled
            )
        }
    }
}
