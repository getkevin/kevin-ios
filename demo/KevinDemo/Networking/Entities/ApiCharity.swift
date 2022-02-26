//
//  ApiCharity.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 10/02/2022.
//

import ObjectMapper

public class ApiCharity: Mappable {
    
    public var id: String!
    public var name: String!
    public var iban: String!
    public var logo: String!
    public var informationUnstructured: String!
    public var country: String!
    public var website: String!
    public var phone: String!
    public var email: String!
    public var address: String!
    
    public init() {}
    
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
        id                          <- map["id"]
        name                        <- map["name"]
        iban                        <- map["iban"]
        logo                        <- map["logo"]
        informationUnstructured     <- map["informationUnstructured"]
        country                     <- map["country"]
        website                     <- map["website"]
        phone                       <- map["phone"]
        email                       <- map["email"]
        address                     <- map["address"]
    }
}
