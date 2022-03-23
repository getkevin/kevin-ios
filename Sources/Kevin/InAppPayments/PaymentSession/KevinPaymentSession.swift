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
    
    private init() { }
    
    internal func notifyPaymentCompletion(paymentId: String) {
        delegate?.onKevinPaymentSucceeded(paymentId: paymentId)
    }
    
    internal func notifyPaymentCancelation(error: Error?) {
        delegate?.onKevinPaymentCanceled(error: error)
    }
    
    /// Inititates the payment flow
    ///
    /// - Parameters:
    ///   - configuration: payment session configuration
    public func initiatePayment(configuration: KevinPaymentSessionConfiguration) {
        if configuration.paymentType == .bank {
            initiateBankPayment(configuration: configuration)
        } else if configuration.paymentType == .card {
            initiateCardPayment(configuration: configuration)
        }
    }
    
    private func initiateBankPayment(configuration: KevinPaymentSessionConfiguration) {
        if configuration.skipAuthentication {
            self.delegate?.onKevinPaymentInitiationStarted(
                controller: self.initializePaymentConfirmation(configuration: configuration)
            )
        } else if configuration.skipBankSelection {
            getPreselectedBank(bankCode: configuration.preselectedBank!, configuration: configuration) { [weak self] bank in
                if bank == nil {
                    self?.delegate?.onKevinPaymentCanceled(error: KevinError(description: "Preselected bank is not available!"))
                } else {
                    self?.delegate?.onKevinPaymentInitiationStarted(
                        controller: self!.initializePaymentConfirmation(configuration: configuration)
                    )
                }
            }
        } else {
            delegate?.onKevinPaymentInitiationStarted(controller: initializeBankSelection(configuration: configuration))
        }
    }

    private func initiateCardPayment(configuration: KevinPaymentSessionConfiguration) {
        delegate?.onKevinPaymentInitiationStarted(controller: initializeCardPayment(configuration: configuration))
    }
    
    //MARK: BankPaymentFlow
    
    private func getPreselectedBank(
        bankCode: String,
        configuration: KevinPaymentSessionConfiguration,
        completion: @escaping (ApiBank?) -> Void
    ) {
        KevinAccountsApiClient.shared.getSupportedBanks(
            token: configuration.paymentId,
            country: configuration.preselectedCountry?.rawValue
        ) { [weak self] response, error in
            if let error = error {
                self?.delegate?.onKevinPaymentCanceled(error: error)
            } else {
                completion(response?.first { $0.id == bankCode })
            }
        }
    }
    
    private func initializeBankSelection(
        configuration: KevinPaymentSessionConfiguration
    ) -> UINavigationController {
        let controller = KevinBankSelectionViewController()
        controller.configuration = KevinBankSelectionConfiguration(
            selectedCountry: configuration.preselectedCountry ?? KevinCountry.lithuania,
            isCountrySelectionDisabled: configuration.disableCountrySelection,
            countryFilter: configuration.countryFilter,
            selectedBankId: configuration.preselectedBank,
            authState: configuration.paymentId,
            exitSlug: "dialog_exit_confirmation_payments_message"
        )
        controller.onContinuation = { [weak self] bankId, _ in
            controller.show(
                self!.initializePaymentConfirmationController(configuration: configuration, selectedBank: bankId),
                sender: nil
            )
        }
        controller.onExit = { [weak self] in
            self?.delegate?.onKevinPaymentCanceled(error: KevinCancelationError(description: "User has canceled the flow!"))
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
            self?.delegate?.onKevinPaymentCanceled(error: KevinCancelationError(description: "User has canceled the flow!"))
        }
        return KevinNavigationViewController(rootViewController: controller)
    }

    //MARK: PaymentConfirmation
    
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
