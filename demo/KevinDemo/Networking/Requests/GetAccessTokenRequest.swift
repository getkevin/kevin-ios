//
//  GetAccessTokenRequest.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 13/06/2022.
//

import ObjectMapper

public final class GetAccessTokenRequest: Mappable {
    
    public var authorizationCode: String!

    public init(authorizationCode: String) {
        self.authorizationCode = authorizationCode
    }
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        authorizationCode <- map["authorizationCode"]
    }
}
