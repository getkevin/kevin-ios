//
//  ApiCharityAccount.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 05/07/2022.
//

import Foundation

public class ApiCharityAccount: Decodable {
    public let currencyCode: String
    public let iban: String
}
