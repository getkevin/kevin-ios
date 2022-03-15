//
//  KevinCardPaymentEvent.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 10/03/2022.
//  Copyright © 2022 kevin.. All rights reserved.
//

import Foundation

enum KevinCardPaymentEvent {
    case softRedirect(cardNumber: String)
    case hardRedirect
    case submittingCardData
}
