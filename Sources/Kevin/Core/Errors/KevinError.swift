//
//  KevinError.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

public class KevinError: Error {
    
    public var description: String?
    
    public init(description: String? = nil) {
        self.description = description
    }
}

extension KevinError: LocalizedError {
    public var errorDescription: String? {
        return description
    }
}
