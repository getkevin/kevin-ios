//
//  KevinAccountLinkingViewController.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation
import UIKit

internal class KevinAccountLinkingViewController :
    KevinViewController<KevinAccountLinkingViewModel, KevinAccountLinkingView, KevinAccountLinkingState, KevinAccountLinkingIntent> {
    
    var configuration: KevinAccountLinkingConfiguration!
    var onClose: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = configuration.linkingType == .bank ?
            "window_account_linking_title".localized(for: Kevin.shared.locale.identifier) :
            "window_account_linking_card_title".localized(for: Kevin.shared.locale.identifier)
        getView().delegate = self
        self.offerIntent(
            KevinAccountLinkingIntent.Initialize(configuration: configuration)
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.handleNotification(notification:)),
            name: .onHandleDeepLinkReceived,
            object: nil
        )
    }
    
    override func onCloseTapped() {
        dismiss(animated: true, completion: onClose)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    @objc func handleNotification(notification: Notification) {
        if let url = notification.object as? URL {
            onAccountLinkingCompleted(callbackUrl: url, error: nil)
        }
    }
}

extension KevinAccountLinkingViewController: KevinAccountLinkingViewDelegate {
    
    func onAccountLinkingCompleted(callbackUrl: URL?, error: Error?) {
        guard let navigationController = navigationController else {
            self.offerIntent(
                KevinAccountLinkingIntent.HandleLinkingCompleted(url: callbackUrl, error: error, configuration: self.configuration)
            )
            return
        }
        if navigationController is KevinNavigationViewController {
            navigationController.dismiss(animated: true, completion: {
                self.offerIntent(
                    KevinAccountLinkingIntent.HandleLinkingCompleted(url: callbackUrl, error: error, configuration: self.configuration)
                )
            })
        } else {
            findRootViewController()?.findNestedNavigationController()?.popToRootViewController(animated: true)
            self.offerIntent(
                KevinAccountLinkingIntent.HandleLinkingCompleted(url: callbackUrl, error: error, configuration: self.configuration)
            )
        }
    }
}
