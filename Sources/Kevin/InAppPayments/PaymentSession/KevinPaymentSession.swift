//
//  KevinPaymentSession.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation
import UIKit

final public class KevinPaymentSession: NSObject {
    
    public weak var delegate: KevinPaymentSessionDelegate?
    
    public static let shared = KevinPaymentSession()

    private var configuration: KevinPaymentSessionConfiguration!
    private let bankConfigurationValidator = ValidateBanksConfigurationUseCase()

    private weak var kevinNavigationController: KevinNavigationViewController?

    private override init() { }
    
    // MARK: - Completion notifiers

    internal func notifyPaymentCompletion(paymentId: String, status: KevinPaymentStatus) {
        delegate?.onKevinPaymentSucceeded(paymentId: paymentId, status: status)
    }
    
    internal func notifyPaymentCancelation(error: Error?) {
        delegate?.onKevinPaymentCanceled(error: error)
    }
    
    // MARK: - Payment initiation

    /// Inititates the payment flow
    ///
    /// - Parameters:
    ///   - configuration: payment session configuration
    public func initiatePayment(configuration: KevinPaymentSessionConfiguration) {
        self.configuration = configuration
        initiateBankPayment(configuration: configuration)
    }
    
    private func initiateBankPayment(configuration: KevinPaymentSessionConfiguration) {
        func onValidationCompletion(selectedBank: ApiBank?) {
            if let _ = selectedBank, configuration.skipBankSelection {
                delegate?.onKevinPaymentInitiationStarted(
                    controller: initializePaymentConfirmation(configuration: configuration)
                )
            } else {
                delegate?.onKevinPaymentInitiationStarted(
                    controller: initializeBankSelection(configuration: configuration)
                )
            }
        }

        if configuration.skipAuthentication {
            delegate?.onKevinPaymentInitiationStarted(
                controller: initializePaymentConfirmation(configuration: configuration)
            )
        } else {
            bankConfigurationValidator.validate(
                token: configuration.paymentId,
                country: configuration.preselectedCountry,
                preselectedBank: configuration.preselectedBank,
                bankFilter: configuration.bankFilter,
                shouldExcludeBanksWithoutAccountLinkingSupport: false
            ) { [weak self] status in
                self?.onBankConfigurationValidation(
                    status: status
                ) { selectedBank in
                    onValidationCompletion(selectedBank: selectedBank)
                }
            }
        }
    }

    private func onBankConfigurationValidation(
        status: ValidateBanksConfigurationUseCase.Status,
        completion: @escaping (ApiBank?) -> Void
    ) {
        switch status {
        case .valid(let selectedBank):
            completion(selectedBank)
            
        case .invalidFilter:
            let error = KevinError(description: "Provided bank filter does not contain supported banks")
            delegate?.onKevinPaymentCanceled(error: error)
            
        case .invalidPreselectedBank:
            let error = KevinError(description: "Provided preselected bank is not supported")
            delegate?.onKevinPaymentCanceled(error: error)
            
        case .unknown(let error):
            delegate?.onKevinPaymentCanceled(error: error)
        }
    }
    
    // MARK: - View initializations

    private func initializeBankSelection(
        configuration: KevinPaymentSessionConfiguration
    ) -> UINavigationController {
        let controller = KevinBankSelectionViewController()
        controller.configuration = KevinBankSelectionConfiguration(
            selectedCountry: configuration.preselectedCountry ?? CountryHelper.defaultCountry,
            isCountrySelectionDisabled: configuration.disableCountrySelection,
            countryFilter: configuration.countryFilter,
            selectedBankId: configuration.preselectedBank,
            authState: configuration.paymentId,
            exitSlug: "dialog_exit_confirmation_payments_message",
            bankFilter: configuration.bankFilter,
            excludeBanksWithoutAccountLinkingSupport: false
        )
        controller.onContinuation = { [weak self] bankId, _ in
            guard let self = self else { return }
            controller.show(
                self.initializePaymentConfirmationController(configuration: configuration, selectedBank: bankId),
                sender: nil
            )
        }
        controller.onExit = { [weak self] in
            self?.delegate?.onKevinPaymentCanceled(error: KevinCancelationError())
        }
        let knvc = buildKevinNavigationController(withRootController: controller)
        kevinNavigationController = knvc
        return knvc
    }
    
    private func initializePaymentConfirmation(
        configuration: KevinPaymentSessionConfiguration
    ) -> UINavigationController {
        let controller = KevinPaymentConfirmationViewController()
        controller.configuration = KevinPaymentConfirmationConfiguration(
            paymentId: configuration.paymentId,
            paymentType: configuration.paymentType,
            selectedBank: configuration.preselectedBank,
            skipAuthentication: configuration.skipAuthentication,
            confirmInteractiveDismiss: configuration.confirmInteractiveDismiss
        )
        let knvc = buildKevinNavigationController(withRootController: controller)
        kevinNavigationController = knvc
        return knvc
    }
    
    private func initializePaymentConfirmationController(
        configuration: KevinPaymentSessionConfiguration,
        selectedBank: String? = nil
    ) -> UIViewController {
        let controller = KevinPaymentConfirmationViewController()
        controller.configuration = KevinPaymentConfirmationConfiguration(
            paymentId: configuration.paymentId,
            paymentType: configuration.paymentType,
            selectedBank: selectedBank ?? configuration.preselectedBank,
            skipAuthentication: configuration.skipAuthentication,
            confirmInteractiveDismiss: configuration.confirmInteractiveDismiss
        )
        return controller
    }
    
    private func buildKevinNavigationController(
        withRootController rootController: UIViewController
    ) -> KevinNavigationViewController {
        let knvc = KevinNavigationViewController(rootViewController: rootController)
        knvc.presentationController?.delegate = self
        
        if #available(iOS 13.0, *), configuration.confirmInteractiveDismiss != .never {
            knvc.isModalInPresentation = true
        }

        return knvc
    }
}

extension KevinPaymentSession: UIAdaptivePresentationControllerDelegate {

    public func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
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
            handler: { [weak self] _ in
                self?.kevinNavigationController?.dismiss(animated: true)
                self?.delegate?.onKevinPaymentCanceled(error: KevinCancelationError())
            }
        ))

        kevinNavigationController?.present(alert, animated: true)
    }
}
