//
//  ApiCountries.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 10/02/2022.
//

import Foundation

public class ApiCountries: Codable {
    public let list: [String]

    enum CodingKeys: String, CodingKey {
        case list = "data"
    }
}
