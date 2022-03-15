//
//  KevinCardPaymentViewDelegate.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 02/03/2022.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

internal protocol KevinCardPaymentViewDelegate: AnyObject {
    func onPageStartLoading()
    func onPageFinishedLoading()
    func onEvent(event: KevinCardPaymentEvent)
    func onUserRedirectAction(shouldRedirect: Bool)
    func onCvvHintTapped()
    func onContinueClicked(
        cardholderName: String,
        cardNumber: String,
        expiryDate: String,
        cvv: String
    )
    func onPaymentResult(url: URL)
}
