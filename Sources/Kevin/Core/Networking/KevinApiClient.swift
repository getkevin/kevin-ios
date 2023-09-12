//
//  KevinApiClient.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

internal class KevinApiClient {
    
    internal var urlSession = URLSession(configuration: URLSessionConfiguration.default)

    internal static let shared = KevinApiClient()
    
    internal func get<ResponseType: KevinApiResponseDecodable>(
        type: ResponseType.Type,
        url: URL,
        additionalHeaders: [String: String] = [:],
        parameters: [String: Any?] = [:],
        completion: @escaping (ResponseType?, HTTPURLResponse?, Error?) -> Void
    ) {
        let request = configuredRequest(for: url, additionalHeaders: additionalHeaders)
        request.httpMethod = "GET"
        
        let params = parameters.compactMapValues({ $0 })
        if !params.isEmpty {
            request.kAddParameters(toURL: params)
        }

        urlSession.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            self.parseResponse(response, body: data, error: error, completion: completion)
        }.resume()
    }
    
    private func defaultHeaders() -> [String: String] {
        var defaultHeaders: [String: String] = [:]
        defaultHeaders["User-Agent"] = UserAgent.userAgentString
        defaultHeaders["Content-Type"] = "application/json"
        return defaultHeaders
    }
    
    private func configuredRequest(for url: URL, additionalHeaders: [String: String] = [:]) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: url)
        var headers = defaultHeaders()
        for (k, v) in additionalHeaders { headers[k] = v }
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        return request
    }
    
    private func parseResponse<ResponseType: KevinApiResponseDecodable>(
        _ response: URLResponse?,
        body: Data?,
        error: Error?,
        completion: @escaping (ResponseType?, HTTPURLResponse?, Error?) -> Void
    ) {
        var httpResponse: HTTPURLResponse?
        if response is HTTPURLResponse {
            httpResponse = response as? HTTPURLResponse
        }

        let safeCompletion: ((ResponseType?, Error?) -> Void) = { responseObject, responseError in
            DispatchQueue.main.async {
                completion(responseObject, httpResponse, responseError)
            }
        }

        if error != nil {
            return safeCompletion(nil, error)
        }

        var jsonDictionary: [AnyHashable: Any]?
        if let body = body {
            do {
                jsonDictionary = try JSONSerialization.jsonObject(with: body, options: []) as? [AnyHashable: Any]
            } catch { }
        }

        if (200..<300).contains(httpResponse!.statusCode),
           let responseObject = ResponseType.decodedObject(from: jsonDictionary) {
            safeCompletion(responseObject, nil)
        } else {
            let error = KevinApiError(jsonDictionary: jsonDictionary, httpResponse: httpResponse)
            safeCompletion(nil, error)
        }
    }
}
