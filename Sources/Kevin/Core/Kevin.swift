//
//  Kevin.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

final public class Kevin {
    
    public var theme = KevinTheme()
    public var locale = Locale(identifier: "en") {
        didSet {
            if !KevinLocaleManager.supportedLocales.contains(locale.identifier) {
                NSLog("Locale is not supported! Fallbacking to English locale.")
                locale = Locale(identifier: "en")
            }
        }
    }
    public var isDeepLinkingEnabled = false
    public var isSandbox = false

    public static let shared = Kevin()
    
    private init() {
        if let preferredLanguage = Locale.preferredLanguages.first {
            let languageIdentifier = String(preferredLanguage.prefix(2))
            if KevinLocaleManager.supportedLocales.contains(languageIdentifier) {
                locale = Locale(identifier: languageIdentifier)
            }
        }
    }
    
    public func handleDeepLinking(url: URL) {
        NotificationCenter.default.post(
            name: .onHandleDeepLinkReceived,
            object: url
        )
    }
}
