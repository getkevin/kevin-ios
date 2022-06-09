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
        
    case getCountryList
    case getCharityList(request: CharityListRequest)
    case initializeBankPayment(request: InitiatePaymentRequest)
    case initializeCardPayment(request: InitiatePaymentRequest)
    
    // MARK: - Declarations
    private static let kevinDemoBaseUrl = URL(string: "https://api.getkevin.eu/demo")!
    private static let kevinMobileDemoBaseUrl = URL(string: "https://mobile-demo.kevin.eu/api/v1/")!

    private var method: HTTPMethod {
        switch self {
        case .getCountryList,
             .getCharityList:
            return .get
        case .initializeBankPayment,
             .initializeCardPayment:
            return .post
        }
    }
    
    private var path: URL {
        switch self {
        case .getCountryList:
            return Self.kevinDemoBaseUrl.appendingPathComponent("countries")
        case .getCharityList:
            return Self.kevinDemoBaseUrl.appendingPathComponent("creditors")
        case .initializeBankPayment( _):
            return Self.kevinMobileDemoBaseUrl.appendingPathComponent("payments/bank/")
        case .initializeCardPayment( _):
            return Self.kevinMobileDemoBaseUrl.appendingPathComponent("payments/card/")
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        case .getCharityList(let request):
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
        let url = path
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
