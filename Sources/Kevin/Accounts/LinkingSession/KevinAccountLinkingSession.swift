//
//  KevinAccountLinkingSession.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation
import UIKit

final public class KevinAccountLinkingSession: NSObject {
    
    public weak var delegate: KevinAccountLinkingSessionDelegate?
    
    public static let shared = KevinAccountLinkingSession()
    
    private var configuration: KevinAccountLinkingSessionConfiguration!
    private let bankConfigurationValidator = ValidateBanksConfigurationUseCase()

    private weak var kevinNavigationController: KevinNavigationViewController?

    private override init() { }
    
    // MARK: - Completion notifiers
    
    internal func notifyAccountLinkingCompletion(
        authorizationCode: String,
        bankId: String?,
        country: KevinCountry?,
        linkingType: KevinAccountLinkingType
    ) {
        notifyBankAccountLinkingCompletion(
            authorizationCode: authorizationCode,
            bankId: bankId,
            country: country
        )
    }

    private func notifyBankAccountLinkingCompletion(
        authorizationCode: String,
        bankId: String?,
        country: KevinCountry?
    ) {
        func onValidationCompletion(selectedBank: ApiBank?) {
            if let selectedBank {
                delegate?.onKevinAccountLinkingSucceeded(
                    authorizationCode: authorizationCode,
                    bank: selectedBank,
                    linkingType: .bank
                )
            } else {
                let error = KevinError(description: "Provided preselected bank is not supported")
                delegate?.onKevinAccountLinkingCanceled(error: error)
            }
        }

        do {
            let shouldExcludeBanksWithoutAccountLinkingSupport = try KevinAccountsPlugin.shared.shouldExcludeBanksWithoutAccountLinkingSupport()
            
            bankConfigurationValidator.validate(
                token: configuration.state,
                country: configuration.preselectedCountry,
                preselectedBank: bankId,
                bankFilter: configuration.bankFilter,
                shouldExcludeBanksWithoutAccountLinkingSupport: shouldExcludeBanksWithoutAccountLinkingSupport
            ) { [weak self] status in
                self?.onBankConfigurationValidation(
                    status: status
                ) { selectedBank in
                    onValidationCompletion(selectedBank: selectedBank)
                }
            }
        } catch {
            delegate?.onKevinAccountLinkingCanceled(error: error)
        }
    }

    internal func notifyAccountLinkingCancelation(error: Error?) {
        delegate?.onKevinAccountLinkingCanceled(error: error)
    }
    
    // MARK: - Account linking initiation

    /// Inititates account linking flow
    ///
    /// - Parameters:
    ///   - configuration: account linking session configuration
    public func initiateAccountLinking(configuration: KevinAccountLinkingSessionConfiguration) {
        self.configuration = configuration
        initializeBankLinking(configuration: configuration)
    }
        
    private func initializeBankLinking(configuration: KevinAccountLinkingSessionConfiguration) {
        func onValidationCompletion(
            selectedBank: ApiBank?,
            shouldExcludeBanksWithoutAccountLinkingSupport: Bool
        ) {
            if let _ = selectedBank, configuration.skipBankSelection {
                delegate?.onKevinAccountLinkingStarted(
                    controller: initializeAccountLinkingConfirmation(configuration: configuration)
                )
            } else {
                delegate?.onKevinAccountLinkingStarted(
                    controller: initializeBankSelection(
                        configuration: configuration,
                        shouldExcludeBanksWithoutAccountLinkingSupport: shouldExcludeBanksWithoutAccountLinkingSupport
                    )
                )
            }
        }
        
        do {
            let shouldExcludeBanksWithoutAccountLinkingSupport = try KevinAccountsPlugin.shared.shouldExcludeBanksWithoutAccountLinkingSupport()
            
            bankConfigurationValidator.validate(
                token: configuration.state,
                country: configuration.preselectedCountry,
                preselectedBank: configuration.preselectedBank,
                bankFilter: configuration.bankFilter,
                shouldExcludeBanksWithoutAccountLinkingSupport: shouldExcludeBanksWithoutAccountLinkingSupport
            ) { [weak self] status in
                self?.onBankConfigurationValidation(
                    status: status
                ) { selectedBank in
                    onValidationCompletion(
                        selectedBank: selectedBank,
                        shouldExcludeBanksWithoutAccountLinkingSupport: shouldExcludeBanksWithoutAccountLinkingSupport
                    )
                }
            }
        } catch {
            delegate?.onKevinAccountLinkingCanceled(error: error)
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
            delegate?.onKevinAccountLinkingCanceled(error: error)
            
        case .invalidPreselectedBank:
            let error = KevinError(description: "Provided preselected bank is not supported")
            delegate?.onKevinAccountLinkingCanceled(error: error)
            
        case .unknown(let error):
            delegate?.onKevinAccountLinkingCanceled(error: error)
        }
    }
    
    // MARK: - View initializations
    
    private func initializeBankSelection(
        configuration: KevinAccountLinkingSessionConfiguration,
        shouldExcludeBanksWithoutAccountLinkingSupport: Bool
    ) -> UINavigationController {
        let controller = KevinBankSelectionViewController()
        controller.configuration = KevinBankSelectionConfiguration(
            selectedCountry: configuration.preselectedCountry ?? CountryHelper.defaultCountry,
            isCountrySelectionDisabled: configuration.disableCountrySelection,
            countryFilter: configuration.countryFilter,
            selectedBankId: configuration.preselectedBank,
            authState: configuration.state,
            exitSlug: "dialog_exit_confirmation_accounts_message",
            bankFilter: configuration.bankFilter,
            excludeBanksWithoutAccountLinkingSupport: shouldExcludeBanksWithoutAccountLinkingSupport
        )
        controller.onContinuation = { [weak self] bankId, country in
            guard let self = self else { return }
            controller.show(
                self.initializeAccountLinkingConfirmationController(
                    configuration: configuration,
                    selectedBank: bankId,
                    selectedCountry: country
                ),
                sender: nil
            )
        }
        controller.onExit = { [weak self] in
            self?.delegate?.onKevinAccountLinkingCanceled(error: KevinCancelationError())
        }
        let knvc = buildKevinNavigationController(withRootController: controller)
        kevinNavigationController = knvc
        return knvc
    }
        
    private func initializeAccountLinkingConfirmation(
        configuration: KevinAccountLinkingSessionConfiguration
    ) -> UINavigationController {
        let controller = initializeAccountLinkingConfirmationController(configuration: configuration)
        let knvc = buildKevinNavigationController(withRootController: controller)
        kevinNavigationController = knvc
        return knvc
    }
    
    private func initializeAccountLinkingConfirmationController(
        configuration: KevinAccountLinkingSessionConfiguration,
        selectedBank: String? = nil,
        selectedCountry: KevinCountry? = nil
    ) -> UIViewController {
        let controller = KevinAccountLinkingViewController()
        controller.configuration = KevinAccountLinkingConfiguration(
            state: configuration.state,
            selectedBankId: selectedBank ?? configuration.preselectedBank,
            selectedCountry: selectedCountry ?? configuration.preselectedCountry,
            linkingType: configuration.linkingType
        )
        controller.onClose = { [weak self] in
            self?.delegate?.onKevinAccountLinkingCanceled(error: KevinCancelationError())
        }
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

extension KevinAccountLinkingSession: UIAdaptivePresentationControllerDelegate {

    public func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        let alert = UIAlertController(
            title: "dialog_exit_confirmation_title".localized(for: Kevin.shared.locale.identifier),
            message: "dialog_exit_confirmation_accounts_message".localized(for: Kevin.shared.locale.identifier),
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
                self?.delegate?.onKevinAccountLinkingCanceled(error: KevinCancelationError())
            }
        ))

        kevinNavigationController?.present(alert, animated: true)
    }
}
