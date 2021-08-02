//
//  ApiError.swift
//  KevinDemo
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation
import ObjectMapper

public class ApiError: Mappable, Error {
    
    public var error: String?
    public var statusCode: Int?
    public var description: String?
    
    public init(error: String? = nil, description: String? = nil, statusCode: Int? = nil) {
        self.error = error
        self.description = description
        self.statusCode = statusCode
    }
    
    required public init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        error       <- map["error"]
        description <- map["error_description"]
    }
    
    public func isUnauthorized() -> Bool {
        return error == "unauthorized"
    }
    
    public func isNoInternet() -> Bool {
        return error == "no_internet"
    }
    
    class public func unknown() -> ApiError {
        return ApiError(error: "unknown")
    }
    
    class public func unauthorized() -> ApiError {
        return ApiError(error: "unauthorized")
    }
    
    public class func mapping(json: String) -> ApiError {
        return ApiError(error: "mapping", description: "mapping failed: \(json)")
    }
    
    public class func noInternet() -> ApiError {
        return ApiError(error: "no_internet", description: "No internet connection")
    }
    
    public class func cancelled() -> ApiError {
        return ApiError(error: "cancelled")
    }
}
