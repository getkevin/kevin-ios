//
//  KevinPaymentSession.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation
import UIKit

final public class KevinPaymentSession {
    
    public weak var delegate: KevinPaymentSessionDelegate?
    
    public static let shared = KevinPaymentSession()
    
    private let bankConfigurationValidator = ValidateBanksConfigurationUseCase()

    private init() { }
    
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
        switch configuration.paymentType {
        case .bank:
            initiateBankPayment(configuration: configuration)
        case .card:
            initiateCardPayment(configuration: configuration)
        }
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

    private func initiateCardPayment(configuration: KevinPaymentSessionConfiguration) {
        delegate?.onKevinPaymentInitiationStarted(
            controller: initializeCardPayment(configuration: configuration)
        )
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
            controller.show(
                self!.initializePaymentConfirmationController(configuration: configuration, selectedBank: bankId),
                sender: nil
            )
        }
        controller.onExit = { [weak self] in
            self?.delegate?.onKevinPaymentCanceled(error: KevinCancelationError())
        }
        return KevinNavigationViewController(rootViewController: controller)
    }

    private func initializeCardPayment(
        configuration: KevinPaymentSessionConfiguration
    ) -> UINavigationController {
        let controller = KevinCardPaymentViewController()
        controller.configuration = KevinCardPaymentConfiguration(
            paymentId: configuration.paymentId,
            exitSlug: "dialog_exit_confirmation_payments_message"
        )
        controller.onExit = { [weak self] in
            self?.delegate?.onKevinPaymentCanceled(error: KevinCancelationError())
        }
        return KevinNavigationViewController(rootViewController: controller)
    }
    
    private func initializePaymentConfirmation(
        configuration: KevinPaymentSessionConfiguration
    ) -> UINavigationController {
        let controller = KevinPaymentConfirmationViewController()
        controller.configuration = KevinPaymentConfirmationConfiguration(
            paymentId: configuration.paymentId,
            paymentType: configuration.paymentType,
            selectedBank: configuration.preselectedBank,
            skipAuthentication: configuration.skipAuthentication
        )
        return KevinNavigationViewController(rootViewController: controller)
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
            skipAuthentication: configuration.skipAuthentication
        )
        return controller
    }
}
