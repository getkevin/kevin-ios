//
//  CharityListRequest.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 10/02/2022.
//

import Foundation

public final class CharityListRequest: Codable {
    public let countryCode: String
    
    public init(countryCode: String) {
        self.countryCode = countryCode
    }
}
