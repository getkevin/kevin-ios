//
//  UIApplication+StatusBar.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 1/8/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import UIKit

extension UIApplication {
    var isLightThemedInterface: Bool {
        if #available(iOS 13.0, *) {
            let interfaceStyle = UIApplication.shared.keyWindow?.overrideUserInterfaceStyle == .unspecified ?
                UIScreen.main.traitCollection.userInterfaceStyle :
                UIApplication.shared.keyWindow?.overrideUserInterfaceStyle ?? .light
            return interfaceStyle == .light
        } else {
            return true
        }
    }
}
