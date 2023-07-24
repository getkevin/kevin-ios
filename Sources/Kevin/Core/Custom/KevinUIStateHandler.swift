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
            (navigationController?.isMovingFromParent ?? false || !forceStopCancellation) &&
            !(navigationController?.viewControllers.last is KevinPaymentConfirmationViewController ||
              navigationController?.viewControllers.last is KevinAccountLinkingViewController)
        }
    }

    private weak var navigationController: UINavigationController?
    
    func setNavigationController(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
}
