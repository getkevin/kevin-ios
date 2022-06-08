//
//  KevinApiBank.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

public class ApiBank {
    
    public let id: String
    public let name: String
    public let officialName: String?
    public let countryCode: String
    public let isSandbox: Bool
    public let imageUri: String
    public let bic: String?
    public let isBeta: Bool
    public let isAccountLinkingSupported: Bool
    
    init(
        id: String,
        name: String,
        officialName: String?,
        countryCode: String,
        isSandbox: Bool,
        imageUri: String,
        bic: String?,
        isBeta: Bool,
        isAccountLinkingSupported: Bool
    ) {
        self.id = id
        self.name = name
        self.officialName = officialName
        self.countryCode = countryCode
        self.isSandbox = isSandbox
        self.imageUri = imageUri
        self.bic = bic
        self.isBeta = isBeta
        self.isAccountLinkingSupported = isAccountLinkingSupported
    }
}
