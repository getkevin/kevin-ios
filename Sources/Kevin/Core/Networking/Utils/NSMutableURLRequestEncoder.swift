//
//  NSMutableURLRequestEncoder.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

class NSMutableURLRequestEncoder {
    
    private static let URLQueryAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="
        let encodableDelimiters = CharacterSet(
            charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")

        return CharacterSet.urlQueryAllowed.subtracting(encodableDelimiters)
    }()
    
    internal class func queryString(from parameters: [String: Any]) -> String {
        return query(parameters)
    }
    
    private class func escape(_ string: String) -> String {
        string.addingPercentEncoding(withAllowedCharacters: URLQueryAllowed) ?? string
    }
    
    private class func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []

        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: escape(key), value: value)
        }
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    
    private class func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        func unwrap<T>(_ any: T) -> Any {
            let mirror = Mirror(reflecting: any)
            guard mirror.displayStyle == .optional, let first = mirror.children.first else {
                return any
            }
            return first.value
        }

        var components: [(String, String)] = []
        switch value {
        case let dictionary as [String: Any]:
            for nestedKey in dictionary.keys.sorted() {
                let value = dictionary[nestedKey]!
                let escapedNestedKey = escape(nestedKey)
                components += queryComponents(fromKey: "\(key)[\(escapedNestedKey)]", value: value)
            }
        case let array as [Any]:
            for (index, value) in array.enumerated() {
                components += queryComponents(fromKey: "\(key)[\(index)]", value: value)
            }
        case let number as NSNumber:
            if String(cString: number.objCType) == "c" {
                components.append((key, escape(number.boolValue ? "true" : "false")))
            } else {
                components.append((key, escape("\(number)")))
            }
        case let bool as Bool:
            components.append((key, escape(bool ? "true" : "false")))
        case let set as Set<AnyHashable>:
            for value in Array(set) {
                components += queryComponents(fromKey: "\(key)", value: value)
            }
        default:
            let unwrappedValue = unwrap(value)
            components.append((key, escape("\(unwrappedValue)")))
        }
        return components
    }
}
