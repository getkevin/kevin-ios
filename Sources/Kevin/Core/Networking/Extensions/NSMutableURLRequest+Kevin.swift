//
//  NSMutableURLRequest+Kevin.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

extension NSMutableURLRequest {
    
    internal func kAddParameters(toURL parameters: [String: Any]) {
        guard let url = url else {
            assertionFailure()
            return
        }
        let urlString = url.absoluteString
        let query = NSMutableURLRequestEncoder.queryString(from: parameters)
        self.url = URL(string: urlString + (url.query != nil ? "&\(query)" : "?\(query)"))
    }
    
    internal func kAddJsonPayload(_ jsonPayload: Data) {
        httpBody = jsonPayload
    }
}
