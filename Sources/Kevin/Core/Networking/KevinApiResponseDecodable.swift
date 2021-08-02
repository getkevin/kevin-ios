//
//  KevinApiResponseDecodable.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

/// Objects conforming to KevinApiResponseDecodable can be automatically converted
/// from a JSON dictionary that was returned from the Kevin API.
internal protocol KevinApiResponseDecodable: NSObjectProtocol {
    static func decodedObject(from response: [AnyHashable: Any]?) -> Self?
}
