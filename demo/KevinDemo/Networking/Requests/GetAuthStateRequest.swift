//
//  GetAuthStateRequest.swift
//  KevinDemo
//
//  Created by Edgar Žigis on 2021-12-26.
//

import ObjectMapper

public final class GetAuthStateRequest: Mappable {
    
    public var scopes: [String]!
    
    public init(scopes: [String]) {
        self.scopes = scopes
    }
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        scopes  <- map["scopes"]
    }
}
