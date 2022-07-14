//
//  InitiateAccountLinkingRequest.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 13/06/2022.
//

import Foundation

public final class InitiateAccountLinkingRequest: Encodable {
    public let scopes: [String]
    
    public init(scopes: [String]) {
        self.scopes = scopes
    }
}
