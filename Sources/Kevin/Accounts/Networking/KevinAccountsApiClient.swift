//
//  KevinAccountsApiClient.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

internal extension URL {

    static func countries(with token: String) -> URL {
        apiURL.appendingPathComponent("platform/frame/countries/\(token)")
    }

    static func banks(with token: String) -> URL {
        apiURL.appendingPathComponent("platform/frame/banks/\(token)")
    }
    
    private static var apiURL: URL {
        get {
            if Kevin.shared.isSandbox {
                return URL(string: "https://sandbox-api.getkevin.eu/")!
            } else {
                return URL(string: "https://api.kevin.eu/")!
            }
        }
    }
}

public class KevinAccountsApiClient {
    
    public static let shared = KevinAccountsApiClient()
    
    public func getSupportedCountries(token: String, completion: @escaping (Array<String>?, Error?) -> Void) {
        KevinApiClient.shared.get(
            type: KevinApiCountryResponse.self,
            url: URL.countries(with: token)
        ) { (response, _, error) in
            completion(response?.countries, error)
        }
    }
    
    public func getSupportedBanks(token: String, country: String?, completion: @escaping (Array<ApiBank>?, Error?) -> Void) {
        KevinApiClient.shared.get(
            type: KevinApiBankListResponse.self,
            url: URL.banks(with: token),
            parameters: ["countryCode": country]
        ) { (response, _, error) in
            completion(response?.banks, error)
        }
    }
}
