//
//  KevinCardPaymentViewDelegate.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 02/03/2022.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

internal protocol KevinCardPaymentViewDelegate: AnyObject {
    func onContinueClicked(
        cardholderName: String,
        cardNumber: String,
        expiryDate: String,
        cvv: String
    )
}
