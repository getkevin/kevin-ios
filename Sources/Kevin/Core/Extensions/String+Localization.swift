//
//  String+Localization.swift
//  
//
//  Created by Daniel Klinge on 05/01/2022.
//

import Foundation

extension String {
    func localized(for lang: String) -> String {
        let path = Bundle.module.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)

        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
