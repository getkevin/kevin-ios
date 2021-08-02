//
//  ApiRequest.swift
//  KevinDemo
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Alamofire
import PromiseKit

public class ApiRequest {
    
    public let requestEndPoint: URLRequestConvertible
    public let pendingPromise: (promise: Promise<Any>, resolver: Resolver<Any>)
    
    public required init<T: URLRequestConvertible>(
        pendingPromise: (promise: Promise<Any>, resolver: Resolver<Any>),
        requestEndPoint: T
    ) {
        self.pendingPromise = pendingPromise
        self.requestEndPoint = requestEndPoint
    }
}
