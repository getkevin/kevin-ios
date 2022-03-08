//
//  KevinApiCardPaymentInfoResponse.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 08/03/2022.
//  Copyright © 2022 kevin.. All rights reserved.
//

import Foundation

public class KevinApiCardPaymentInfoResponse: NSObject, KevinApiResponseDecodable {
    
    public var amount: Double!
    public var currencyCode: String!

    public override required init() {
        super.init()
    }
    
    public static func decodedObject(from response: [AnyHashable : Any]?) -> Self? {
        guard let response = response else {
            return nil
        }
        let responseDictionary = response as NSDictionary
    
        let cardPaymentInfoResponse = self.init()
        if let currencyCode = responseDictionary.kGetString(forKey: "currencyCode") {
            cardPaymentInfoResponse.currencyCode = currencyCode
        }
        if let amount = responseDictionary.kGetNumber(forKey: "amount") {
            cardPaymentInfoResponse.amount = amount.doubleValue
        }
        return cardPaymentInfoResponse
    }
}
