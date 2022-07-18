//
//  ApiCharities.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 10/02/2022.
//

import Foundation

public class ApiCharities: Decodable {
    public let list: [ApiCharity]
    
    enum CodingKeys: String, CodingKey {
        case list = "data"
    }
}
