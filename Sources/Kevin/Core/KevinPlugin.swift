//
//  KevinPlugin.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

public protocol KevinPlugin {
    func getKey() -> String
    func isConfigured() -> Bool
}
