//
//  KevinUIStateHandler.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 14/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import UIKit

internal class KevinUIStateHandler {
    
    var forceStopCancellation = false
    var isCancellationInvoked: Bool {
        get {
            return !(navigationController is KevinNavigationViewController) &&
            (navigationController?.isMovingFromParent ?? false || !forceStopCancellation)
        }
    }

    private var previousNavigationBarBackgroundColor: UIColor?
    private var previousStatusBarBackgroundColor: UIColor?
    
    private let navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func setNavigationBarColor(_ color: UIColor) {
        previousNavigationBarBackgroundColor = navigationController?.navigationBar.backgroundColor
        previousStatusBarBackgroundColor = UIApplication.shared.statusBarUIView?.backgroundColor
        setNavigationBarColor(navigationBarColor: color, statusBarColor: color)
    }
    
    func resetState() {
        setNavigationBarColor(
            navigationBarColor: previousNavigationBarBackgroundColor,
            statusBarColor: previousStatusBarBackgroundColor
        )
    }
    
    private func setNavigationBarColor(navigationBarColor: UIColor?, statusBarColor: UIColor?) {
        if !(navigationController is KevinNavigationViewController) {
            navigationController?.navigationBar.backgroundColor = navigationBarColor
            if #available(iOS 12.0, *) {
                if UIScreen.main.traitCollection.userInterfaceStyle == .light {
                    UIApplication.shared.statusBarUIView?.backgroundColor = statusBarColor
                }
            }
        }
    }
}
