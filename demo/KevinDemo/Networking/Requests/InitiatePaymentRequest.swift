//
//  InitiatePaymentRequest.swift
//  KevinDemo
//
//  Created by Edgar Žigis on 2021-12-26.
//

import ObjectMapper

public final class InitiatePaymentRequest: Mappable {
    
    public var amount: String!
    
    public init(amount: String) {
        self.amount = amount
    }
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        amount  <- map["amount"]
    }
}
