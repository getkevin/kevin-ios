//
//  ApiCharities.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 10/02/2022.
//

import ObjectMapper

public class ApiCharities: Mappable {
    
    public var list: [ApiCharity]!

    public init() {}
    
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
        list   <- map["data"]
    }
}
