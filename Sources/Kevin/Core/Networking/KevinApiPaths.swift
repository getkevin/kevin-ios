//
//  KevinApiPaths.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 06/06/2022.
//  Copyright © 2022 kevin.. All rights reserved.
//

import Foundation

class KevinApiPaths {
    
    static let bankLinkingUrl = "https://\(host)/login/%@/%@/preview"
    static let bankPaymentUrl = "https://\(host)/login/%@/%@/preview"
    static let bankPaymentAuthenticatedUrl = "https://\(host)/payments/%@/processing"

    static var host: String {
        get {
            Kevin.shared.isSandbox ? "psd2-sandbox.kevin.eu" : "psd2.kevin.eu"
        }
    }
}
