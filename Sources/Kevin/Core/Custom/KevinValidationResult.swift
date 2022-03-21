//
//  KevinButton.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 04/03/2022.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

enum KevinValidationResult: Equatable {
    case valid
    case invalid(message: String)
    
    var isValid: Bool {
        return self == .valid
    }
    
    var errorMessage: String? {
        guard case .invalid(message: let message) = self else {
            return nil
        }
        return message
    }
}
