//
//  RequestHeaders.swift
//  KevinDemo
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

public class RequestHeaders {
    
    public var headers = [URLRequestHeader]()
    
    public init() {
    }
    
    public init(headers: [URLRequestHeader]) {
        self.headers = headers
    }
    
    public func updateHeader(_ header: URLRequestHeader) {
        headers.removeAll(where: { $0.headerKey == header.headerKey })
        headers.append(header)
    }
}
