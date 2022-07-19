//
//  KevinAccountsConfiguration.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

public class KevinAccountsConfiguration {
    
    let callbackUrl: URL
    let showUnsupportedBanks: Bool

    private init(
        callbackUrl: URL,
        showUnsupportedBanks: Bool
    ) {
        self.callbackUrl = callbackUrl
        self.showUnsupportedBanks = showUnsupportedBanks
    }
    
    public class Builder {
        
        private let callbackUrl: URL
        private let showUnsupportedBanks: Bool

        public init(
            callbackUrl: URL,
            showUnsupportedBanks: Bool = false
        ) {
            self.callbackUrl = callbackUrl
            self.showUnsupportedBanks = showUnsupportedBanks
        }
        
        public func build() -> KevinAccountsConfiguration {
            return KevinAccountsConfiguration(
                callbackUrl: callbackUrl,
                showUnsupportedBanks: showUnsupportedBanks
            )
        }
    }
}
