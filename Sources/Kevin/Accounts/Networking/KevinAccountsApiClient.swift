//
//  KevinAccountsApiClient.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

public class KevinAccountsApiClient {
    
    public static let shared = KevinAccountsApiClient()
    
    public func getSupportedCountries(token: String, completion: @escaping (Array<String>?, Error?) -> Void) {
        KevinApiClient.shared.get(
            type: KevinApiCountryResponse.self,
            endpoint: "platform/frame/countries/\(token)"
        ) { (response, _, error) in
            completion(response?.countries, error)
        }
    }
    
    public func getSupportedBanks(token: String, country: String?, completion: @escaping (Array<ApiBank>?, Error?) -> Void) {
        KevinApiClient.shared.get(
            type: KevinApiBankResponse.self,
            endpoint: "platform/frame/banks/\(token)",
            parameters: ["countryCode":country as Any]
        ) { (response, _, error) in
            completion(response?.banks, error)
        }
    }
}
