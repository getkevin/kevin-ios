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
    
    private var isCancellationInvoked = false
    private var previousNavigationBarBackgroundColor: UIColor?
    private var previousStatusBarBackgroundColor: UIColor?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "window_payment_confirmation_title".localized(for: Kevin.shared.locale.identifier)
        getView().delegate = self
        self.offerIntent(
            KevinPaymentConfirmationIntent.Initialize(configuration: configuration)
        )
        previousNavigationBarBackgroundColor = navigationController?.navigationBar.backgroundColor
        previousStatusBarBackgroundColor = UIApplication.shared.statusBarUIView?.backgroundColor
        if !(navigationController is KevinNavigationViewController) {
            findRootViewController()?.findNestedNavigationController()?.navigationBar.backgroundColor = Kevin.shared.theme.navigationBarBackgroundColor
            if #available(iOS 12.0, *) {
                if UIScreen.main.traitCollection.userInterfaceStyle == .light {
                    UIApplication.shared.statusBarUIView?.backgroundColor = Kevin.shared.theme.navigationBarBackgroundColor
                }
            }
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isCancellationInvoked = !(navigationController is KevinNavigationViewController) && isMovingFromParent
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isCancellationInvoked {
            if configuration.skipAuthentication || configuration.paymentType == .card {
                self.offerIntent(
                    KevinPaymentConfirmationIntent.HandlePaymentCompleted(
                        url: nil,
                        error: KevinCancelationError(description: "Payment was canceled!")
                    )
                )
            }
        }
        findRootViewController()?.findNestedNavigationController()?.navigationBar.backgroundColor = previousNavigationBarBackgroundColor
        UIApplication.shared.statusBarUIView?.backgroundColor = previousStatusBarBackgroundColor
    }
    
    override func onCloseTapped() {
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
                self.dismiss(animated: true, completion: nil)
                self.offerIntent(
                    KevinPaymentConfirmationIntent.HandlePaymentCompleted(
                        url: nil,
                        error: KevinCancelationError(description: "Payment was canceled!")
                    )
                )
            }
        ))
        present(alert, animated: true)
    }
}

extension KevinPaymentConfirmationViewController: KevinPaymentConfirmationViewDelegate {
    
    func onPaymentCompleted(callbackUrl: URL, error: Error?) {
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
