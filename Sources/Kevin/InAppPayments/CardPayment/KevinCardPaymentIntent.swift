//
//  KevinCardPaymentIntent.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 02/03/2022.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

internal class KevinCardPaymentIntent: IKevinIntent {
    
    internal class Initialize: KevinCardPaymentIntent {
        
        let configuration: KevinCardPaymentConfiguration
        
        init(configuration: KevinCardPaymentConfiguration) {
            self.configuration = configuration
        }
    }
    
    internal class HandlePageStartedLoading: KevinCardPaymentIntent { }
    
    internal class HandlePageFinishedLoading: KevinCardPaymentIntent { }
    
    internal class HandleCardPaymentEvent: KevinCardPaymentIntent {
        let event: KevinCardPaymentEvent
        
        init(event: KevinCardPaymentEvent) {
            self.event = event
        }
    }

    internal class HandleOnContinueClicked: KevinCardPaymentIntent {
        let cardholderName: String
        let cardNumber: String
        let expiryDate: String
        let cvv: String

        init(
            cardholderName: String,
            cardNumber: String,
            expiryDate: String,
            cvv: String
        ) {
            self.cardholderName = cardholderName
            self.cardNumber = cardNumber
            self.expiryDate = expiryDate
            self.cvv = cvv
        }
    }
    
    internal class HandlePaymentResult: KevinCardPaymentIntent {
        let url: URL
        let error: Error?

        init(
            url: URL,
            error: Error?
        ) {
            self.url = url
            self.error = error
        }
    }
    
    internal class HandleUserSoftRedirect: KevinCardPaymentIntent {
        let shouldRedirect: Bool
        
        init(shouldRedirect: Bool) {
            self.shouldRedirect = shouldRedirect
        }
    }
}
