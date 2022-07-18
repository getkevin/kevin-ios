//
//  InitiatePaymentRequest.swift
//  KevinDemo
//
//  Created by Edgar Žigis on 2021-12-26.
//

import Foundation

public final class InitiatePaymentRequest: Encodable {    
    public let amount: String
    public let email: String
    public let iban: String
    public let creditorName: String
    
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
}
