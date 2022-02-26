//
//  KevinNavigationViewController.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import UIKit

internal class KevinNavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
        
        interactivePopGestureRecognizer?.delegate = self
        interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func configureNavigationBar() {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIApplication.shared.isLightThemedInterface ?
            Kevin.shared.theme.navigationBarStyle.backgroundColorLightMode :
            Kevin.shared.theme.navigationBarStyle.backgroundColorDarkMode
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Kevin.shared.theme.navigationBarStyle.titleColor]
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
        } else {
            navigationBar.barTintColor = UIApplication.shared.isLightThemedInterface ?
            Kevin.shared.theme.navigationBarStyle.backgroundColorLightMode :
            Kevin.shared.theme.navigationBarStyle.backgroundColorDarkMode
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Kevin.shared.theme.navigationBarStyle.titleColor]
        }
    }
}

extension KevinNavigationViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if interactivePopGestureRecognizer != gestureRecognizer {
            return true
        }
        return viewControllers.first != visibleViewController
    }
}

extension KevinNavigationViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard viewControllers.count != 1 else {
            viewController.createCloseButtonItem()
            return
        }
        viewController.createBackButtonItem()
    }
}

