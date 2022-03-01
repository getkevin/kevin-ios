//
//  UIColor+Hex.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 28/02/2022.
//  Copyright © 2021 kevin.. All rights reserved.
//

import UIKit

extension UIColor {
    var hexString: String {
        guard let components = self.cgColor.components else {
            return ""
        }
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0

        if components.count < 4 {
            r = components[0]
            g = components[0]
            b = components[0]
        } else {
            r = components[0]
            g = components[1]
            b = components[2]
        }
        
        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString
    }
}
