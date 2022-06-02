//
//  NSAttributedString+NSRange.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 01/06/2022.
//  Copyright © 2022 kevin.. All rights reserved.
//

import Foundation

public extension NSAttributedString {
    func range(of substring: String) -> NSRange? {
        guard let range = self.string.range(of: substring) else {
            return nil
        }
        
        return NSRange(range, in: self.string)
    }
}
