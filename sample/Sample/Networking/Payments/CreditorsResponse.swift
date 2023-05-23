//
//  CreditorsResponse.swift
//  Sample
//
//  Created by Kacper Dziubek on 19/05/2023.
//

import Foundation

struct CreditorsResponse: Decodable {
    let data: [Creditor]
}

struct Creditor: Decodable {
    let name: String
    let accounts: [CreditorAccount]
}

struct CreditorAccount: Decodable {
    let currencyCode: String
    let iban: String
}
