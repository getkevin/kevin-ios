//
//  KevinInAppPaymentsConfiguration.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

/// Mandatory in-app payments configuration
public class KevinInAppPaymentsConfiguration {
    
    let callbackUrl: URL
    
    private init(
        callbackUrl: URL
    ) {
        self.callbackUrl = callbackUrl
    }
    
    public class Builder {
        
        private let callbackUrl: URL
        
        /// Creates an instance with the given callbackUrl.
        ///
        /// - Parameters:
        ///   - callbackUrl: callback url to be used in in app payments plugin
        public init(callbackUrl: URL) {
            self.callbackUrl = callbackUrl
        }
        
        public func build() -> KevinInAppPaymentsConfiguration {
            return KevinInAppPaymentsConfiguration(
                callbackUrl: callbackUrl
            )
        }
    }
}
