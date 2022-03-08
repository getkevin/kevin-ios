//
//  KevinCardPaymentState.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 02/03/2022.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

internal struct KevinCardPaymentState : IKevinState {
    let url: URL
    let amount: String = ""
    let showCardDetails: Bool = true
}
