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
        let components = self.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        
        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString
    }
}
