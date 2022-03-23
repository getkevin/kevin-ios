//
//  KevinApiBankResponse.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 11/03/2022.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

public class KevinApiBankResponse: NSObject, KevinApiResponseDecodable {
    
    public var bank: ApiBank!
    
    public override required init() {
        super.init()
    }
    
    public static func decodedObject(from response: [AnyHashable : Any]?) -> Self? {
        guard let response = response else {
            return nil
        }
        let responseDictionary = response as NSDictionary
    
        let bankResponse = self.init()
        
        bankResponse.bank = ApiBank(
            id: responseDictionary.kGetString(forKey: "id")!,
            name: responseDictionary.kGetString(forKey: "name")!,
            officialName: responseDictionary.kGetString(forKey: "officialName"),
            countryCode: responseDictionary.kGetString(forKey: "countryCode")!,
            isSandbox: responseDictionary.kGetBoolean(forKey: "isSandbox", or: true),
            imageUri: responseDictionary.kGetString(forKey: "imageUri")!,
            bic: responseDictionary.kGetString(forKey: "bic"),
            isBeta: responseDictionary.kGetBoolean(forKey: "isBeta", or: true)
        )
        return bankResponse
    }
}
