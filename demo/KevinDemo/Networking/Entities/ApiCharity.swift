//
//  ApiCharity.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 10/02/2022.
//

import Foundation

public class ApiCharity: Decodable {
    public let id: Int
    public let name: String
    public let logo: String
    public let informationUnstructured: String
    public let country: String
    public let website: String
    public let phone: String
    public let email: String
    public let address: String?
    public let accounts: [ApiCharityAccount]
}
