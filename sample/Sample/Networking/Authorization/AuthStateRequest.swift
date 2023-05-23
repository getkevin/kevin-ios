//
//  AuthStateRequest.swift
//  Sample
//
//  Created by Kacper Dziubek on 19/05/2023.
//

import Foundation

struct AuthStateRequest: Encodable {
    let scopes: [String]
    let redirectUrl: String
}
