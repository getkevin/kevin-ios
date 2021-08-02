//
//  TokenRefresherProtocol.swift
//  KevinDemo
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation
import PromiseKit

public protocol TokenRefresherProtocol {
    func refreshToken() -> Promise<Bool>
    func isRefreshing() -> Bool
}
