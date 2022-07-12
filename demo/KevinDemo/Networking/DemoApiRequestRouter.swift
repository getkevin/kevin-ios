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
    case initializeAccountLinking(request: InitiateAccountLinkingRequest)
    case getAccessToken(request: GetAccessTokenRequest)
    case refreshAccessToken(request: RefreshAccessTokenRequest)
    case initializeBankPayment(request: InitiatePaymentRequest)
    case initializeLinkedBankPayment(request: InitiatePaymentRequest, accessToken: String)
    case initializeCardPayment(request: InitiatePaymentRequest)
    
    // MARK: - Declarations
    private static let kevinDemoBaseUrl = URL(string: "https://api.getkevin.eu/demo")!
    private static let kevinMobileDemoBaseUrl = URL(string: "https://mobile-demo.kevin.eu/api/v1/")!

    private var method: HTTPMethod {
        switch self {
        case .getCountryList,
             .getCharityList,
             .getAccessToken:
            return .get
        case .refreshAccessToken,
             .initializeAccountLinking,
             .initializeBankPayment,
             .initializeLinkedBankPayment,
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
        case .initializeAccountLinking:
            return Self.kevinMobileDemoBaseUrl.appendingPathComponent("auth/initiate")
        case .getAccessToken( _):
            return Self.kevinMobileDemoBaseUrl.appendingPathComponent("auth/tokens")
        case .refreshAccessToken( _):
            return Self.kevinMobileDemoBaseUrl.appendingPathComponent("auth/refreshToken")
        case .initializeBankPayment( _):
            return Self.kevinMobileDemoBaseUrl.appendingPathComponent("payments/bank/")
        case .initializeLinkedBankPayment( _, _):
            return Self.kevinMobileDemoBaseUrl.appendingPathComponent("payments/bank/linked/")
        case .initializeCardPayment( _):
            return Self.kevinMobileDemoBaseUrl.appendingPathComponent("payments/card/")
        }
    }
    
    private var parameters: Parameters? {
        do {
            switch self {
            case .getCharityList(let request):
                return try request.toDictionary()
            case .initializeAccountLinking(let request):
                return try request.toDictionary()
            case .getAccessToken(let request):
                return try request.toDictionary()
            case .refreshAccessToken(let request):
                return try request.toDictionary()
            case .initializeBankPayment(let request):
                return try request.toDictionary()
            case .initializeLinkedBankPayment(let request, _):
                return try request.toDictionary()
            case .initializeCardPayment(let request):
                return try request.toDictionary()
            default:
                return nil
            }
        } catch {
            return nil
        }
    }
    
    private var headers: HTTPHeaders {
        switch self {
        case .initializeLinkedBankPayment(_, let accessToken):
            return [HTTPHeader(name: "Authorization", value: "Bearer \(accessToken)")]
        default:
            return [:]
        }
    }
}

extension DemoApiRequestRouter: URLRequestConvertible {
    
    func asURLRequest() throws -> URLRequest {
        let url = path
        var urlRequest = URLRequest(url: url)
        urlRequest.method = method
        urlRequest.headers = headers
        
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
