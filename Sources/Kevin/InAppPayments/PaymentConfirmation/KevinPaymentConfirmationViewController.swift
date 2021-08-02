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
