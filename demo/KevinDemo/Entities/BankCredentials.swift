//
//  BankCredentials.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 14/06/2022.
//

import Foundation

public class BankCredentials: Codable {
    
    public let bankId: String
    public let accessToken: String?
    public let refreshToken: String?
    
    public init(
        bankId: String,
        accessToken: String? = nil,
        refreshToken: String? = nil
    ) {
        self.bankId = bankId
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
