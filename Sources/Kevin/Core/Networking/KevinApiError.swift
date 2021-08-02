//
//  KevinApiError.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

public class KevinApiError: Error {
    
    public var code: Int?
    public var name: String?
    public var description: String?
    public var httpStatusCode: Int?
    
    public init(code: Int? = nil, name: String? = nil, description: String? = nil, httpStatusCode: Int? = nil) {
        self.code = code
        self.name = name
        self.description = description
        self.httpStatusCode = httpStatusCode
    }
    
    public init(jsonDictionary: [AnyHashable: Any]?, httpResponse: HTTPURLResponse? = nil) {
        guard let dictionary = (jsonDictionary as NSDictionary?),
            let errorDictionary = dictionary.kGetDictionary(forKey: "error") as NSDictionary?
        else {
            return
        }
        self.code = errorDictionary.kGetInt(forKey: "code", or: 0)
        self.name = errorDictionary.kGetString(forKey: "name")
        self.description = errorDictionary.kGetString(forKey: "description")
        self.httpStatusCode = httpResponse?.statusCode
    }
    
    public func isNoInternet() -> Bool {
        return name == "no_internet"
    }
    
    public class func noInternet() -> KevinApiError {
        return KevinApiError(name: "no_internet", description: "No internet connection!")
    }
    
    public class func unknown() -> KevinApiError {
        return KevinApiError(name: "unknown", description: "Unknown error!")
    }
}
