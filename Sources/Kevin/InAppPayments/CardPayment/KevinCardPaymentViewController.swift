//
//  KevinCardPaymentViewController.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 02/03/2022.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation
import UIKit

internal class KevinCardPaymentViewController :
    KevinViewController<KevinCardPaymentViewModel, KevinCardPaymentView, KevinCardPaymentState, KevinCardPaymentIntent> {
    
    var configuration: KevinCardPaymentConfiguration!
    
    public var onExit: (() -> ())?

    private var uiStateHandler: KevinUIStateHandler!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "window_payment_confirmation_title".localized(for: Kevin.shared.locale.identifier)
        getView().delegate = self
        getViewModel().viewAction = observeViewActions
        self.offerIntent(
            KevinCardPaymentIntent.Initialize(configuration: configuration)
        )
        uiStateHandler = KevinUIStateHandler()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        uiStateHandler.setNavigationController(navigationController: navigationController)
        uiStateHandler.setNavigationBarColor(
            UIApplication.shared.isLightThemedInterface ?
            Kevin.shared.theme.navigationBarStyle.backgroundColorLightMode :
                Kevin.shared.theme.navigationBarStyle.backgroundColorDarkMode
        )
        uiStateHandler.forceStopCancellation = false
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if uiStateHandler.isCancellationInvoked {
            self.onExit?()
            uiStateHandler.resetState()
        }
    }
    
    override func onCloseTapped() {
        let alert = UIAlertController(
            title: "dialog_exit_confirmation_title".localized(for: Kevin.shared.locale.identifier),
            message: configuration.exitSlug.localized(for: Kevin.shared.locale.identifier),
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
                self.uiStateHandler.forceStopCancellation = true
                self.dismiss(animated: true, completion: nil)
                self.onExit?()
            }
        ))
        present(alert, animated: true)
    }

    private func observeViewActions(action: IKevinIntent) {
        if let action = action as? KevinCardPaymentViewAction.ShowFieldValidations {
            getView().showFormErrors(
                isCardholderNameValid: action.cardholderNameValidation,
                isCardNumberValid: action.cardNumberValidation,
                isExpiryDateValid: action.expiryDateValidation,
                isCvvValid: action.cvvValidation
            )
        } else if let action = action as? KevinCardPaymentViewAction.SubmitCardForm {
            getView().submitForm(
                cardholderName: action.cardholderName,
                cardNumber: action.cardNumber,
                expiryDate: action.expiryDate,
                cvv: action.cvv
            )
        }
    }
}

extension KevinCardPaymentViewController: KevinCardPaymentViewDelegate {
    func onContinueClicked(cardholderName: String, cardNumber: String, expiryDate: String, cvv: String) {
        self.offerIntent(
            KevinCardPaymentIntent.HandleOnContinueClicked(
                cardholderName: cardholderName,
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cvv: cvv
            )
        )
    }
}
