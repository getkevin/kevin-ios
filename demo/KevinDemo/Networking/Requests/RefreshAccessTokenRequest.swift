//
//  RefreshAccessTokenRequest.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 14/06/2022.
//

import ObjectMapper

public final class RefreshAccessTokenRequest: Mappable {
    
    public var refreshToken: String!

    public init(refreshToken: String) {
        self.refreshToken = refreshToken
    }
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        refreshToken <- map["refreshToken"]
    }
}
