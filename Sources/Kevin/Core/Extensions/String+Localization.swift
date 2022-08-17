//
//  String+Localization.swift
//  kevin.iOS
//
//  Created by Daniels Klinge on 1/5/21.
//  Copyright © 2022 kevin.. All rights reserved.
//

import Foundation

extension String {
    
    func localized(for lang: String) -> String {
        if let path = Bundle.current.path(forResource: lang, ofType: "lproj") {
            return NSLocalizedString(self, tableName: nil, bundle: Bundle(path: path)!, value: "", comment: "")
        }
        return self
    }
}
