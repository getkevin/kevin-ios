//
//  KevinPaymentConfirmationIntent.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

internal class KevinPaymentConfirmationIntent: IKevinIntent {
    
    internal class Initialize: KevinPaymentConfirmationIntent {
        
        let configuration: KevinPaymentConfirmationConfiguration
        
        init(configuration: KevinPaymentConfirmationConfiguration) {
            self.configuration = configuration
        }
    }

    internal class HandlePaymentCompleted: KevinPaymentConfirmationIntent {
        
        public let url: URL
        public let error: Error?
        
        init(url: URL, error: Error?) {
            self.url = url
            self.error = error
        }
    }
}
