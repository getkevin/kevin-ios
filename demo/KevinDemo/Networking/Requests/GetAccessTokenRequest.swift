//
//  GetAccessTokenRequest.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 13/06/2022.
//

import Foundation

public final class GetAccessTokenRequest: Encodable {    
    public let authorizationCode: String
    
    public init(authorizationCode: String) {
        self.authorizationCode = authorizationCode
    }
}
