//
//  ResponseDecoder.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 13/07/2022.
//  Copyright © 2022 kevin.. All rights reserved.
//

import Foundation

class ResponseDecoder {
    
    private let decoder = JSONDecoder()
    
    func decodeRequest<E: Decodable>(with body: Any) throws -> E {
        let data = try makeData(with: body)
        do {
            return try decoder.decode(E.self, from: data)
        } catch {
            throw makeError(with: data)
        }
    }
    
    func makeData(with body: Any) throws -> Data {
        do {
            return try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            throw ApiError.unknown()
        }
    }
    
    func makeError(with data: Data) -> ApiError {
        let error = try? decoder.decode(ApiError.self, from: data)
        return error ?? .unknown()
    }
}
