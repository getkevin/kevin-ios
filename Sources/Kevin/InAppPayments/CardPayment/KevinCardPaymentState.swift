//
//  KevinCardPaymentState.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 02/03/2022.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

internal struct KevinCardPaymentState : IKevinState {
    var url: URL?
    var amount: String?
    var showCardDetails: Bool = true
    var isContinueEnabled: Bool = false
    var loadingState: KevinLoadingState = .notLoading
}
