//
//  InitiateAccountLinking.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 13/06/2022.
//

import ObjectMapper

public final class InitiateAccountLinking: Mappable {
    
    public var scopes: [String]!

    public init(scopes: [String]) {
        self.scopes = scopes
    }
    
    required public init?(map: Map) { }
    
    public func mapping(map: Map) {
        scopes <- map["scopes"]
    }
}
