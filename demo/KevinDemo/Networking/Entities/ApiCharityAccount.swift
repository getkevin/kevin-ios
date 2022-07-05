//
//  ApiCharityAccount.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 05/07/2022.
//

import ObjectMapper

public class ApiCharityAccount: Mappable {
    
    public var currencyCode: String!
    public var iban: String!
    
    public init() {}
    
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
        currencyCode <- map["currencyCode"]
        iban         <- map["iban"]
    }
}
