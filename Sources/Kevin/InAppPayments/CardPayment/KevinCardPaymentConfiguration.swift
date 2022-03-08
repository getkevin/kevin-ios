//
//  KevinCardPaymentConfiguration.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 02/03/2022.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

internal struct KevinCardPaymentConfiguration {
    
    public let paymentId: String
    public let exitSlug: String

    public init(
        paymentId: String,
        exitSlug: String
    ) {
        self.paymentId = paymentId
        self.exitSlug = exitSlug
    }
}
