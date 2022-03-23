//
//  KevinCardPaymentEvent.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 10/03/2022.
//  Copyright © 2022 kevin.. All rights reserved.
//

import Foundation

enum KevinCardPaymentEvent {
    case softRedirect(cardNumber: String = "")
    case hardRedirect
    case submittingCardData
    
    func getRawValue() -> String {
        switch (self) {
        case .softRedirect(_ ):
            return "SOFT_REDIRECT_MODAL"
        case .hardRedirect:
            return "HARD_REDIRECT_MODAL"
        case .submittingCardData:
            return "CARD_PAYMENT_SUBMITTING"
        }
    }
}
