//
//  ApiAccessToken.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 14/06/2022.
//

import Foundation

public class ApiAccessToken: Decodable {
    public let tokenType: String
    public let accessToken: String
    public let accessTokenExpiresIn: Double
    public let refreshToken: String
    public let refreshTokenExpiresIn: Double
}
