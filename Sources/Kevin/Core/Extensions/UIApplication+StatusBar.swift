//
//  UIApplication+StatusBar.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 1/8/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import UIKit

extension UIApplication {
    var statusBarUIView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 38482
            let keyWindow = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
            
            if let statusBar = keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                guard let statusBarFrame = keyWindow?.windowScene?.statusBarManager?.statusBarFrame else { return nil }
                let statusBarView = UIView(frame: statusBarFrame)
                statusBarView.tag = tag
                keyWindow?.addSubview(statusBarView)
                return statusBarView
            }
        } else if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        } else {
            return nil
        }
    }
    
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
