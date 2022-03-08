//
//  KevinApiCardPaymentInfo.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 08/03/2022.
//  Copyright © 2022 kevin.. All rights reserved.
//

import Foundation

public class ApiCardPaymentInfo {
    
    public let amount: Double
    public let currencyCode: String
    
    init(
        amount: Double,
        currencyCode: String
    ) {
        self.amount = amount
        self.currencyCode = currencyCode
    }
}
