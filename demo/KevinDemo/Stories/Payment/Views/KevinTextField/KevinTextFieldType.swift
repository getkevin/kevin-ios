//
//  KevinTextFieldType.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 21/06/2022.
//

import SwiftUI

enum KevinTextFieldType {
    case email
    case amount
    
    var textContentType: UITextContentType? {
        switch self {
        case .email:
            return .emailAddress
        case .amount:
            return nil
        }
    }
    
    var keyboardType: UIKeyboardType {
        switch self {
        case .email:
            return .emailAddress
        case .amount:
            return .decimalPad
        }
    }
}
