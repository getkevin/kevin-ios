//
//  BaseRequestAdapter.swift
//  KevinDemo
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Alamofire
import Foundation

public class BaseApiRequestAdapter: RequestInterceptor {
    
    private let headers: RequestHeaders?
    private let credentials: JWTCredentials?
    
    public init(credentials: JWTCredentials?, headers: RequestHeaders? = nil) {
        self.credentials = credentials
        self.headers = headers
    }
    
    public func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var urlRequest = urlRequest
        
        if let credentials = credentials {
            guard let token = credentials.token?.string else {
                return completion(.failure(ApiError.unauthorized()))
            }
            urlRequest.headers.add(.authorization(bearerToken: token))
        }
        
        if let headers = headers {
            headers.headers.forEach {
                urlRequest.headers.add(name: $0.headerKey, value: $0.value)
            }
        }

        completion(.success(urlRequest))
    }
    
    public func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        completion(.doNotRetry)
    }
}
