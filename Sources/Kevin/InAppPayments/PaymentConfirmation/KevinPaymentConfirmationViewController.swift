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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("window_payment_confirmation_title", bundle: Bundle.module, comment: "")
        getView().delegate = self
        self.offerIntent(
            KevinPaymentConfirmationIntent.Initialize(configuration: configuration)
        )
    }
    
    override func onCloseTapped() {
        let alert = UIAlertController(
            title: NSLocalizedString("dialog_exit_confirmation_title", bundle: Bundle.module, comment: ""),
            message: NSLocalizedString("dialog_exit_confirmation_payments_message", bundle: Bundle.module, comment: ""),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("no", bundle: Bundle.module, comment: ""),
            style: .cancel,
            handler: nil
        ))
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("yes", bundle: Bundle.module, comment: ""),
            style: .default,
            handler: { _ in
                self.dismiss(animated: true, completion: nil)
                self.offerIntent(
                    KevinPaymentConfirmationIntent.HandlePaymentCompleted(
                        url: nil,
                        error: KevinError(description: "Payment was canceled!")
                    )
                )
            }
        ))
        present(alert, animated: true)
    }
}

extension KevinPaymentConfirmationViewController: KevinPaymentConfirmationViewDelegate {
    
    func onPaymentCompleted(callbackUrl: URL, error: Error?) {
        navigationController?.dismiss(animated: true, completion: {
            self.offerIntent(
                KevinPaymentConfirmationIntent.HandlePaymentCompleted(url: callbackUrl, error: error)
            )
        })
    }
}
