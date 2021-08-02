//
//  KevinApiCountryResponse.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

public class KevinApiCountryResponse: NSObject, KevinApiResponseDecodable {
    
    public var countries: Array<String>!
    
    public override required init() {
        super.init()
    }
    
    public static func decodedObject(from response: [AnyHashable : Any]?) -> Self? {
        guard let response = response else {
            return nil
        }
        let responseDictionary = response as NSDictionary
    
        let countryResponse = self.init()
        if let data = responseDictionary.kGetArray(forKey: "data") {
            countryResponse.countries = data as? Array<String>
        }
        return countryResponse
    }
}
