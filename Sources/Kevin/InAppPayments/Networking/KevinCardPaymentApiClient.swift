//
//  KevinCardPaymentApiClient.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 08/03/2022.
//  Copyright © 2022 kevin.. All rights reserved.
//

import Foundation

public class KevinCardPaymentApiClient {
    
    public static let shared = KevinCardPaymentApiClient()
    
    public func getCardPaymentInfo(paymentId: String, completion: @escaping (ApiCardPaymentInfo?, Error?) -> Void) {
        KevinApiClient.shared.get(
            type: KevinApiCardPaymentInfoResponse.self,
            endpoint: "platform/frame/card/payment/\(paymentId)"
        ) { (response, _, error) in
            var cardPaymentInfo: ApiCardPaymentInfo?
            
            if let amount = response?.amount, let currencyCode = response?.currencyCode {
                cardPaymentInfo = ApiCardPaymentInfo(amount: amount, currencyCode: currencyCode)
            }
            
            completion(cardPaymentInfo, error)
        }
    }
}
