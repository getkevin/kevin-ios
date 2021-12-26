//
//  KevinDemoApp.swift
//  KevinDemo
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Alamofire
import Foundation

enum DemoApiRequestRouter {
    
    case getAuthState(request: GetAuthStateRequest)
    case initializeBankPayment(request: InitiatePaymentRequest)
    case initializeCardPayment(request: InitiatePaymentRequest)
    
    // MARK: - Declarations
    private static let baseURL = URL(string: "https://your.kevin.url/")!
    
    private var method: HTTPMethod {
        switch self {
        case .getAuthState,
             .initializeBankPayment,
             .initializeCardPayment:
            return .post
        }
    }
    
    private var path: String {
        switch self {
            
        case .getAuthState( _):
            return "auth/initiate/"
        case .initializeBankPayment( _):
            return "payments/bank/"
        case .initializeCardPayment( _):
            return "payments/card/"
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        case .getAuthState(let request):
            return request.toJSON()
        case .initializeBankPayment(let request):
            return request.toJSON()
        case .initializeCardPayment(let request):
            return request.toJSON()
        default:
            return nil
        }
    }
}

extension DemoApiRequestRouter: URLRequestConvertible {
    
    func asURLRequest() throws -> URLRequest {
        let url = Self.baseURL.appendingPathComponent(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.method = method
        
        switch method {
        case .post,
             .put:
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: parameters)
        default:
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
}
