//
//  InitiatePaymentRequest.swift
//  Sample
//
//  Created by Kacper Dziubek on 19/05/2023.
//

import Foundation

struct InitiatePaymentRequest: Encodable {
    let amount: String
    let currencyCode: String
    let email: String
    let iban: String
    let creditorName: String
    let redirectUrl: String
}
