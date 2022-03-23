//
//  KevinCardPaymentApiClient.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 08/03/2022.
//  Copyright © 2022 kevin.. All rights reserved.
//

import Foundation

public class KevinPaymentsApiClient {
    
    public static let shared = KevinPaymentsApiClient()
    
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
    
    public func getBankFromCardNumber(paymentId: String, cardNumberPart: String, completion: @escaping (ApiBank?, Error?) -> Void) {
        KevinApiClient.shared.get(
            type: KevinApiBankResponse.self,
            endpoint: "platform/frame/banks/cards/\(paymentId)/\(cardNumberPart)"
        ) { (response, _, error) in
            completion(response?.bank, error)
        }
    }
}
