//
//  BaseApiClient.swift
//  KevinDemo
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Alamofire
import Foundation
import PromiseKit

open class PSBaseApiClient {
    
    private let session: Session
    private let credentials: JWTCredentials?
    private let tokenRefresher: TokenRefresherProtocol?
    private let logger: LoggerProtocol?
    private var requestsQueue = [ApiRequest]()
    
    private var refreshPromise: Promise<Bool>?
    private let workQueue = DispatchQueue(label: "\(PSBaseApiClient.self)")
    
    private let responseDecoder = ResponseDecoder()
    
    public init(
        session: Session,
        credentials: JWTCredentials?,
        tokenRefresher: TokenRefresherProtocol?,
        logger: LoggerProtocol? = nil
    ) {
        self.session = session
        self.tokenRefresher = tokenRefresher
        self.credentials = credentials
        self.logger = logger
    }
    
    public func cancelAllOperations() {
        session.cancelAllRequests()
    }
    
    public func doRequest<RC: URLRequestConvertible, E: Decodable>(requestRouter: RC) -> Promise<E> {
        let request = createRequest(requestRouter)
        executeRequest(request)

        return request
            .pendingPromise
            .promise
            .map(on: workQueue) { [weak self] body in
                guard let `self` = self else {
                    throw ApiError.unknown()
                }
                return try self.responseDecoder.decodeRequest(with: body)
            }
    }
        
    private func createRequest<RC: URLRequestConvertible>(_ endpoint: RC) -> ApiRequest {
        ApiRequest(pendingPromise: Promise<Any>.pending(), requestEndPoint: endpoint)
    }
    
    private func executeRequest(_ apiRequest: ApiRequest) {
        workQueue.async {
            guard let urlRequest = apiRequest.requestEndPoint.urlRequest else {
                return apiRequest.pendingPromise.resolver.reject(ApiError.unknown())
            }
            
            if self.tokenRefresher != nil, self.credentials != nil, self.credentials!.isExpired() {
                self.requestsQueue.append(apiRequest)
                self.refreshToken()
            } else {
                self.logger?.log(
                    level: .DEBUG,
                    message: "--> \(urlRequest.url!.absoluteString)",
                    request: urlRequest
                )
                
                self.session
                    .request(apiRequest.requestEndPoint)
                    .responseJSON(queue: self.workQueue) { response in
                        self.handleResponse(response, for: apiRequest, with: urlRequest)
                    }
            }
        }
    }
    
    private func handleResponse(
        _ response: AFDataResponse<Any>,
        for apiRequest: ApiRequest,
        with urlRequest: URLRequest
    ) {
        guard let urlResponse = response.response else {
            return handleMissingUrlResponse(for: apiRequest, with: response.error)
        }
        
        let responseData = try? response.result.get()
        let statusCode = urlResponse.statusCode
        let logMessage = "<-- \(urlRequest.url!.absoluteString) \(statusCode)"
        
        if 200 ... 299 ~= statusCode {
            logger?.log(
                level: .DEBUG,
                message: logMessage,
                response: urlResponse
            )
            apiRequest.pendingPromise.resolver.fulfill(responseData ?? "")
        } else {
            let error = mapError(body: responseData)
            error.statusCode = statusCode
            
            logger?.log(
                level: .ERROR,
                message: logMessage,
                response: urlResponse,
                error: error
            )
            
            if statusCode == 401 {
                handleUnauthorizedRequest(apiRequest, error: error)
            } else {
                apiRequest.pendingPromise.resolver.reject(error)
            }
        }
    }
    
    private func handleMissingUrlResponse(
        for apiRequest: ApiRequest,
        with afError: AFError?
    ) {
        let error: ApiError
        
        switch afError {
        case .explicitlyCancelled:
            error = .cancelled()
        case .sessionTaskFailed(let e as URLError) where
                e.code == .notConnectedToInternet ||
                e.code == .networkConnectionLost ||
                e.code == .dataNotAllowed:
            error = .noInternet()
        default:
            error = .unknown()
        }
        
        apiRequest.pendingPromise.resolver.reject(error)
    }
    
    private func handleUnauthorizedRequest(
        _ apiRequest: ApiRequest,
        error: ApiError
    ) {
        guard tokenRefresher != nil else {
            return apiRequest.pendingPromise.resolver.reject(error)
        }
        guard credentials != nil else {
            return apiRequest.pendingPromise.resolver.reject(error)
        }
        
        if credentials!.hasRecentlyRefreshed() {
            return executeRequest(apiRequest)
        }
        
        requestsQueue.append(apiRequest)
        refreshToken()
    }
    
    private func mapError(body: Any?) -> ApiError {
        guard let body = body, let data = try? responseDecoder.makeData(with: body) else {
            return .unknown()
        }
        return responseDecoder.makeError(with: data)
    }
    
    private func refreshToken() {
        guard
            refreshPromise == nil,
            let tokenRefresher = tokenRefresher
        else {
            return
        }
        
        refreshPromise = tokenRefresher.refreshToken()
        refreshPromise?
            .done(on: workQueue) { _ in
                self.resumeQueue()
                self.refreshPromise = nil
            }
            .catch(on: workQueue) { error in
                self.cancelQueue(error: error)
                self.refreshPromise = nil
            }
    }
    
    private func resumeQueue() {
        requestsQueue.forEach(executeRequest)
        requestsQueue.removeAll()
    }
    
    private func cancelQueue(error: Error) {
        requestsQueue.forEach { request in
            request.pendingPromise.resolver.reject(error)
        }
        requestsQueue.removeAll()
    }
}
