//
//  RequestHeader.swift
//  KevinDemo
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

public enum URLRequestHeader {
    
    case acceptLanguage(String)
    case other(headerKey: String, value: String)
    
    var headerKey: String {
        switch self {
        case .acceptLanguage(_):
            return "Accept-Language"
        case .other(let key, _):
            return key
        }
    }
    
    var value: String {
        switch self {
        case .acceptLanguage(let locale):
            return locale
        case .other(_, let val):
            return val
        }
    }
}
