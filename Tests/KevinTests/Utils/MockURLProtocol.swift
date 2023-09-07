//
//  MockURLProtocol.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 07/09/2023.
//  Copyright © 2023 kevin.. All rights reserved.
//

import Foundation

var mockURLSession: URLSession {
    let configuration: URLSessionConfiguration = .ephemeral
    configuration.protocolClasses = [MockURLProtocol.self]
    return URLSession(configuration: configuration)
}

struct MockRequestHandler {
    let url: String
    var statusCode: Int = 200
    var jsonResponse: String?
    var customHandler: (() -> Void)?
}

class MockURLProtocol: URLProtocol {
    private static var error: Error?
    private static var requestHandlers: [MockRequestHandler] = []

    static func add(handler: MockRequestHandler) {
        requestHandlers.append(handler)
    }

    static func clearHandlers() {
        requestHandlers.removeAll()
    }

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let error = MockURLProtocol.error {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }

        let handler = Self.requestHandlers.first {
            $0.url == request.url?.absoluteString
        }
        guard let handler else {
            assertionFailure(
                "Missing requestHandler for \(String(describing: request.url?.absoluteString))" +
                "Configured handlers are: \n \(Self.requestHandlers.map { $0.url }.joined(separator: " \n"))"
            )
            return
        }

        let response = HTTPURLResponse(
            url: URL(string: handler.url)!,
            statusCode: handler.statusCode,
            httpVersion: nil,
            headerFields: ["Content-Type": "application/json"]
        )!

        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        if let response = handler.jsonResponse {
            client?.urlProtocol(self, didLoad: response.data(using: .utf8)!)
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {

    }
}
