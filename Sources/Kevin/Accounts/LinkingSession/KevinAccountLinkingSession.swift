//
//  KevinAccountLinkingSession.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation
import UIKit

final public class KevinAccountLinkingSession {
    
    public weak var delegate: KevinAccountLinkingSessionDelegate?
    
    public static let shared = KevinAccountLinkingSession()
    
    private var configuration: KevinAccountLinkingSessionConfiguration!
    
    private init() { }
    
    internal func notifyAccountLinkingCompletion(
        authorizationCode: String,
        bankId: String,
        country: KevinCountry?
    ) {
        getPreselectedBank(
            state: configuration.state,
            bankCode: bankId,
            country: country
        ) { [weak self] bank in
            if bank == nil {
                self?.delegate?.onKevinAccountLinkingCanceled(error: KevinError(description: "Preselected bank is not available!"))
            } else {
                self?.delegate?.onKevinAccountLinkingSucceeded(
                    authorizationCode: authorizationCode,
                    bank: bank!
                )
            }
        }
    }
    
    internal func notifyAccountLinkingCancelation(error: Error?) {
        delegate?.onKevinAccountLinkingCanceled(error: error)
    }
    
    /// Inititates account linking flow
    ///
    /// - Parameters:
    ///   - configuration: account linking session configuration
    public func initiateAccountLinking(configuration: KevinAccountLinkingSessionConfiguration) {
        self.configuration = configuration
        if configuration.skipBankSelection {
            getPreselectedBank(
                state: configuration.state,
                bankCode: configuration.preselectedBank!,
                country: configuration.preselectedCountry
            ) { [weak self] bank in
                if bank == nil {
                    self?.delegate?.onKevinAccountLinkingCanceled(error: KevinError(description: "Preselected bank is not available!"))
                } else {
                    self?.delegate?.onKevinAccountLinkingStarted(
                        controller: self!.initializeAccountLinkingConfirmation(configuration: configuration)
                    )
                }
            }
        } else {
            delegate?.onKevinAccountLinkingStarted(controller: initializeBankSelection(configuration: configuration))
        }
    }
    
    private func getPreselectedBank(
        state: String,
        bankCode: String,
        country: KevinCountry?,
        completion: @escaping (ApiBank?) -> Void
    ) {
        KevinAccountsApiClient.shared.getSupportedBanks(
            token: state,
            country: country?.rawValue
        ) { [weak self] response, error in
            if let error = error {
                self?.delegate?.onKevinAccountLinkingCanceled(error: error)
            } else {
                completion(response?.first { $0.id == bankCode })
            }
        }
    }
    
    private func initializeBankSelection(
        configuration: KevinAccountLinkingSessionConfiguration
    ) -> UINavigationController {
        let controller = KevinBankSelectionViewController()
        controller.configuration = KevinBankSelectionConfiguration(
            selectedCountry: configuration.preselectedCountry ?? KevinCountry.lithuania,
            isCountrySelectionDisabled: configuration.disableCountrySelection,
            countryFilter: configuration.countryFilter,
            selectedBankId: configuration.preselectedBank,
            authState: configuration.state,
            exitSlug: "dialog_exit_confirmation_accounts_message"
        )
        controller.onContinuation = { [weak self] bankId, country in
            controller.show(
                self!.initializeAccountLinkingConfirmationController(
                    configuration: configuration,
                    selectedBank: bankId,
                    selectedCountry: country
                ),
                sender: nil
            )
        }
        controller.onExit = { [weak self] in
            self?.delegate?.onKevinAccountLinkingCanceled(error: KevinCancelationError(description: "User has canceled the flow!"))
        }
        return KevinNavigationViewController(rootViewController: controller)
    }
    
    //MARK: AccountLinkingConfirmation
    
    private func initializeAccountLinkingConfirmation(
        configuration: KevinAccountLinkingSessionConfiguration
    ) -> UINavigationController {
        let controller = KevinAccountLinkingViewController()
        controller.configuration = KevinAccountLinkingConfiguration(
            state: configuration.state,
            selectedBankId: configuration.preselectedBank!,
            selectedCountry: configuration.preselectedCountry
        )
        return KevinNavigationViewController(rootViewController: controller)
    }
    
    private func initializeAccountLinkingConfirmationController(
        configuration: KevinAccountLinkingSessionConfiguration,
        selectedBank: String? = nil,
        selectedCountry: KevinCountry?
    ) -> UIViewController {
        let controller = KevinAccountLinkingViewController()
        controller.configuration = KevinAccountLinkingConfiguration(
            state: configuration.state,
            selectedBankId: selectedBank ?? configuration.preselectedBank!,
            selectedCountry: selectedCountry
        )
        return controller
    }
}
