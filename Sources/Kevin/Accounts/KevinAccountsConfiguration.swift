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
    
    private init(
        callbackUrl: URL
    ) {
        self.callbackUrl = callbackUrl
    }
    
    public class Builder {
        
        private let callbackUrl: URL
        
       public init(callbackUrl: URL) {
            self.callbackUrl = callbackUrl
        }
        
        public func build() -> KevinAccountsConfiguration {
            return KevinAccountsConfiguration(
                callbackUrl: callbackUrl
            )
        }
    }
}
