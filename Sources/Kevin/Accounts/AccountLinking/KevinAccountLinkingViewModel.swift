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
        let baseUrl = configuration.linkingType == .bank ?
            String(format: KevinPlatformUtil.bankLinkingUrl, configuration.state, configuration.selectedBankId!) :
            String(format: KevinPlatformUtil.cardLinkingUrl, configuration.state)
        
        onStateChanged(
            KevinAccountLinkingState(
                bankRedirectUrl: appendUrlParameters(urlString: baseUrl),
                accountLinkingType: configuration.linkingType
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
                    bankId: configuration.selectedBankId,
                    country: configuration.selectedCountry,
                    linkingType: configuration.linkingType
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
