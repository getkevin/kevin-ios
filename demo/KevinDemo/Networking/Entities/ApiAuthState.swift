//
//  ApiAuthState.swift
//  KevinDemo
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

public class ApiAuthState: Decodable {
    public let authorizationLink: String
    public let state: String
}
