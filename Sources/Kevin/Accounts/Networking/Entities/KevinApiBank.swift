//
//  KevinApiBank.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation
import UIKit

public class ApiBank {
    
    public let id: String
    public let name: String
    public let officialName: String?
    public let countryCode: String
    public let isSandbox: Bool
    private var _imageUri: String = ""
    public var imageUri: String {
        get {
            var imageUri = _imageUri
            
            if !UIApplication.shared.isLightThemedInterface {
                let imageUriParts = _imageUri.components(separatedBy: "images/")
                
                if imageUriParts.count > 1 {
                    imageUri = "\(imageUriParts.first!)images/white/\(imageUriParts.last!)"
                }
            }
            
            return imageUri
        }
        set {
            _imageUri = newValue
        }
    }
    public let bic: String?
    public let isBeta: Bool
    
    init(
        id: String,
        name: String,
        officialName: String?,
        countryCode: String,
        isSandbox: Bool,
        imageUri: String,
        bic: String?,
        isBeta: Bool
    ) {
        self.id = id
        self.name = name
        self.officialName = officialName
        self.countryCode = countryCode
        self.isSandbox = isSandbox
        self._imageUri = imageUri
        self.bic = bic
        self.isBeta = isBeta
    }
}
