//
//  GetAuthStateRequest.swift
//  KevinDemo
//
//  Created by Edgar Žigis on 2021-12-26.
//

import Foundation

public final class GetAuthStateRequest: Codable {
    public let scopes: [String]
    
    public init(scopes: [String]) {
        self.scopes = scopes
    }
}
