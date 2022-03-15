//
//  KevinApiBankListResponse.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

public class KevinApiBankListResponse: NSObject, KevinApiResponseDecodable {
    
    public var banks: Array<ApiBank>!
    
    public override required init() {
        super.init()
    }
    
    public static func decodedObject(from response: [AnyHashable : Any]?) -> Self? {
        guard let response = response else {
            return nil
        }
        let responseDictionary = response as NSDictionary
    
        let bankResponse = self.init()
        if let data = responseDictionary.kGetArray(forKey: "data") as? Array<[AnyHashable : Any]> {
            bankResponse.banks = (data as Array<NSDictionary>).map {
                ApiBank(
                    id: $0.kGetString(forKey: "id")!,
                    name: $0.kGetString(forKey: "name")!,
                    officialName: $0.kGetString(forKey: "officialName"),
                    countryCode: $0.kGetString(forKey: "countryCode")!,
                    isSandbox: $0.kGetBoolean(forKey: "isSandbox", or: true),
                    imageUri: $0.kGetString(forKey: "imageUri")!,
                    bic: $0.kGetString(forKey: "bic"),
                    isBeta: $0.kGetBoolean(forKey: "isBeta", or: true)
                )
            }
        }
        return bankResponse
    }
}
