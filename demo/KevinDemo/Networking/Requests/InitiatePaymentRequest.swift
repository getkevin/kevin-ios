//
//  InitiatePaymentRequest.swift
//  KevinDemo
//
//  Created by Edgar Žigis on 2021-12-26.
//

import ObjectMapper

public final class InitiatePaymentRequest: Mappable {
    
    public var amount: String!
    public var email: String!
    public var iban: String!
    public var creditorName: String!

    public init(
        amount: String,
        email: String,
        iban: String,
        creditorName: String
    ) {
        self.amount = amount
        self.email = email
        self.iban = iban
        self.creditorName = creditorName
    }
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        amount        <- map["amount"]
        email         <- map["email"]
        iban          <- map["iban"]
        creditorName  <- map["creditorName"]
    }
}
