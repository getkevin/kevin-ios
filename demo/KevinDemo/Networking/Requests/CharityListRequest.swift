//
//  CharityListRequest.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 10/02/2022.
//

import ObjectMapper

public final class CharityListRequest: Mappable {
    
    public var countryCode: String!
    
    public init(countryCode: String) {
        self.countryCode = countryCode.uppercased() == "LT" ? "LT" : "EE"
    }
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        countryCode  <- map["countryCode"]
    }
}
