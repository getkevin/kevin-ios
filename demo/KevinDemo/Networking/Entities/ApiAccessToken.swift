//
//  ApiAccessToken.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 14/06/2022.
//

import ObjectMapper

public class ApiAccessToken: Mappable {
    
    public var tokenType: String!
    public var accessToken: String!
    public var accessTokenExpiresIn: Double!
    public var refreshToken: String!
    public var refreshTokenExpiresIn: Double!

    public init() {}
    
    required public init?(map: Map) {}
    
    public func mapping(map: Map) {
        tokenType             <- map["tokenType"]
        accessToken           <- map["accessToken"]
        accessTokenExpiresIn  <- map["accessTokenExpiresIn"]
        refreshToken          <- map["refreshToken"]
        refreshTokenExpiresIn <- map["refreshTokenExpiresIn"]
    }
}
