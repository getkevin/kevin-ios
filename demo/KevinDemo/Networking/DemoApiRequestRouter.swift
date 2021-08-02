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
    
    case getAuthState
    case initializeBankPayment
    case initializeCardPayment
    
    // MARK: - Declarations
    private static let baseURL = URL(string: "https://your.base.url/")!
    
    private var method: HTTPMethod {
        switch self {
        case .getAuthState,
             .initializeBankPayment,
             .initializeCardPayment:
            return .get
        }
    }
    
    private var path: String {
        switch self {
            
        case .getAuthState:
            return "examples/auth_example.php"
        case .initializeBankPayment:
            return "examples/bank_card_example.php"
        case .initializeCardPayment:
            return "examples/card_example.php"
        }
    }
    
    private var parameters: Parameters? {
        switch self {
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
