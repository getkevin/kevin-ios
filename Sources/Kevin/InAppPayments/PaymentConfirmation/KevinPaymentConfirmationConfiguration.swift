//
//  KevinPaymentConfirmationState.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

internal struct KevinPaymentConfirmationConfiguration {
    let paymentId: String
    let paymentType: KevinPaymentType
    let selectedBank: String?
    let skipAuthentication: Bool
}
