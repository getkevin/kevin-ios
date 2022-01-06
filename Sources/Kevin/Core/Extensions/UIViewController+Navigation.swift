//
//  UIViewController+Navigation.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import UIKit

extension UIViewController {
    
    internal func findRootViewController() -> UIViewController? {
        return UIApplication.shared.windows.filter {
            $0.isKeyWindow
        }.first?.rootViewController
    }
    
    internal func findNestedNavigationController() -> UINavigationController? {
        if let navigationController = self as? UINavigationController {
            return navigationController
        } else if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.findNestedNavigationController()
        }

        for child in children {
            return child.findNestedNavigationController()
        }

        return nil
    }
    
    internal func createBackButtonItem(
        with customAction: Selector? = #selector(onBackTapped),
        tintColor: UIColor? = nil
    ) {
        let button = UIBarButtonItem(image: Kevin.shared.theme.backButtonImage, style: .plain, target: self, action: customAction)
        
        self.navigationItem.leftBarButtonItem = button
        self.navigationController?.navigationBar.tintColor = Kevin.shared.theme.navigationBarTintColor
    }
    
    internal func createCloseButtonItem(
        with customAction: Selector? = #selector(onCloseTapped),
        tintColor: UIColor? = nil
    ) {
        let button = UIBarButtonItem(image: Kevin.shared.theme.closeButtonImage, style: .plain, target: self, action: customAction)
        
        self.navigationItem.leftBarButtonItem = button
        self.navigationController?.navigationBar.tintColor = Kevin.shared.theme.navigationBarTintColor
    }
    
    @objc internal func onBackTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc internal func onCloseTapped() {
        dismiss(animated: true, completion: nil)
    }
}
