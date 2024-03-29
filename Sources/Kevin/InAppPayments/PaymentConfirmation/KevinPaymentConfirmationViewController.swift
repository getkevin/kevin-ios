//
//  KevinPaymentConfirmationViewController.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation
import UIKit

internal class KevinPaymentConfirmationViewController :
    KevinViewController<KevinPaymentConfirmationViewModel, KevinPaymentConfirmationView, KevinPaymentConfirmationState, KevinPaymentConfirmationIntent> {
    
    var configuration: KevinPaymentConfirmationConfiguration!
    
    private var uiStateHandler: KevinUIStateHandler?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "window_payment_confirmation_title".localized(for: Kevin.shared.locale.identifier)
        getView().delegate = self
        self.offerIntent(
            KevinPaymentConfirmationIntent.Initialize(configuration: configuration)
        )
        uiStateHandler = KevinUIStateHandler()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.handleNotification(notification:)),
            name: .onHandleDeepLinkReceived,
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if configuration.skipAuthentication {
            uiStateHandler?.setNavigationController(navigationController: navigationController)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if uiStateHandler?.isCancellationInvoked ?? false {
            NotificationCenter.default.removeObserver(self)
            if configuration.skipAuthentication {
                self.offerIntent(
                    KevinPaymentConfirmationIntent.HandlePaymentCompleted(
                        url: nil,
                        error: KevinErrors.paymentCanceled
                    )
                )
            }
        }
    }
    
    override func onCloseTapped() {
        switch configuration.confirmInteractiveDismiss {
        case .always: presentCloseAlert()
        case .never:  dismissView()
        }
    }
    
    private func presentCloseAlert() {
        let alert = UIAlertController(
            title: "dialog_exit_confirmation_title".localized(for: Kevin.shared.locale.identifier),
            message: "dialog_exit_confirmation_payments_message".localized(for: Kevin.shared.locale.identifier),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: "no".localized(for: Kevin.shared.locale.identifier),
            style: .cancel,
            handler: nil
        ))
        alert.addAction(UIAlertAction(
            title: "yes".localized(for: Kevin.shared.locale.identifier),
            style: .default,
            handler: { _ in
                self.dismissView()
            }
        ))
        present(alert, animated: true)
    }
    
    private func dismissView() {
        dismiss(animated: true, completion: nil)
        offerIntent(
            KevinPaymentConfirmationIntent.HandlePaymentCompleted(
                url: nil,
                error: KevinErrors.paymentCanceled
            )
        )
    }
    
    @objc func handleNotification(notification: Notification) {
        if let url = notification.object as? URL {
            onPaymentCompleted(callbackUrl: url, error: nil)
        }
    }
}

extension KevinPaymentConfirmationViewController: KevinPaymentConfirmationViewDelegate {
    
    func onPaymentCompleted(callbackUrl: URL?, error: Error?) {
        guard let navigationController = navigationController else {
            self.offerIntent(
                KevinPaymentConfirmationIntent.HandlePaymentCompleted(url: callbackUrl, error: error)
            )
            return
        }
        if navigationController is KevinNavigationViewController {
            navigationController.dismiss(animated: true, completion: {
                self.offerIntent(
                    KevinPaymentConfirmationIntent.HandlePaymentCompleted(url: callbackUrl, error: error)
                )
            })
        } else {
            findRootViewController()?.findNestedNavigationController()?.popToRootViewController(animated: true)
            self.offerIntent(
                KevinPaymentConfirmationIntent.HandlePaymentCompleted(url: callbackUrl, error: error)
            )
        }
    }
}
