//
//  ApiAuthState.swift
//  KevinDemo
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import ObjectMapper

public class ApiAuthState: Mappable {
    
    public var authorizationLink: String!
    public var state: String!

    public init() {}
    
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
        authorizationLink   <- map["authorizationLink"]
        state               <- map["state"]
    }
}
