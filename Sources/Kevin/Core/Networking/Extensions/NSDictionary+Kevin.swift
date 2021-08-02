//
//  NSDictionary+Kevin.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

@objc extension NSDictionary {
    
    internal func kGetDictionary(forKey key: String) -> [AnyHashable: Any]? {
        let value = self[key]
        if value != nil && (value is [AnyHashable: Any]) {
            return value as? [AnyHashable: Any]
        }
        return nil
    }
    
    internal func kGetArray(forKey key: String) -> [Any]? {
        let value = self[key]
        if value != nil {
            return value as? [Any]
        }
        return nil
    }

    internal func kGetBoolean(forKey key: String, or defaultValue: Bool) -> Bool {
        let value = self[key]
        if value != nil {
            if let value = value as? NSNumber {
                return value.boolValue
            }
            if value is NSString {
                let string = (value as? String)?.lowercased()
                if (string == "true") || (string as NSString?)?.boolValue ?? false {
                    return true
                } else {
                    return false
                }
            }
        }
        return defaultValue
    }

    internal func kGetDate(forKey key: String) -> Date? {
        let value = self[key]
        if let value = value as? NSNumber {
            let timeInterval = value.doubleValue
            return Date(timeIntervalSince1970: TimeInterval(timeInterval))
        } else if let value = value as? NSString {
            let timeInterval = value.doubleValue
            return Date(timeIntervalSince1970: TimeInterval(timeInterval))
        }
        return nil
    }

    internal func kGetInt(forKey key: String, or defaultValue: Int) -> Int {
        let value = self[key]
        if let value = value as? NSNumber {
            return value.intValue
        } else if let value = value as? NSString {
            return Int(value.intValue)
        }
        return defaultValue
    }

    internal func kGetNumber(forKey key: String) -> NSNumber? {
        return self[key] as? NSNumber
    }

    internal func kGetString(forKey key: String) -> String? {
        let value = self[key]
        if value != nil && (value is NSString) {
            return value as? String
        }
        return nil
    }

    internal func kGetURL(forKey key: String) -> URL? {
        let value = self[key]
        if value != nil && (value is NSString) && ((value as? String)?.count ?? 0) > 0 {
            return URL(string: value as? String ?? "")
        }
        return nil
    }
}
