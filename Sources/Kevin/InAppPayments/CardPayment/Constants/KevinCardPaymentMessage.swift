//
//  KevinCardPaymentMessage.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 10/03/2022.
//  Copyright © 2022 kevin.. All rights reserved.
//

import Foundation

enum KevinCardPaymentMessage: String {
    case softRedirect = "SOFT_REDIRECT_MODAL"
    case hardRedirect = "HARD_REDIRECT_MODAL"
    case cardPaymentSubmitting = "CARD_PAYMENT_SUBMITTING"
}
