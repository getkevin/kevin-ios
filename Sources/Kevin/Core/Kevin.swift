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

    public static let shared = Kevin()
    
    private init() { }
}
