//
//  ApiPayment.swift
//  KevinDemo
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import ObjectMapper

public class ApiPayment: Mappable {
    
    public var id: String!

    public init() {}
    
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
        id   <- map["id"]
    }
}
