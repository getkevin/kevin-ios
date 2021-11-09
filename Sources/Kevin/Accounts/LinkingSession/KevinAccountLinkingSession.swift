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
    
    private init() { }
    
    internal func notifyAccountLinkingCompletion(requestId: String, code: String) {
        delegate?.onKevinAccountLinkingSucceeded(requestId: requestId, code: code)
    }
    
    internal func notifyAccountLinkingCancelation(error: Error?) {
        delegate?.onKevinAccountLinkingCanceled(error: error)
    }
    
    /// Inititates account linking flow
    ///
    /// - Parameters:
    ///   - configuration: account linking session configuration
    public func initiateAccountLinking(configuration: KevinAccountLinkingSessionConfiguration) {
        if configuration.skipBankSelection {
            getPreselectedBank(bankCode: configuration.preselectedBank!, configuration: configuration) { [weak self] bank in
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
        bankCode: String,
        configuration: KevinAccountLinkingSessionConfiguration,
        completion: @escaping (ApiBank?) -> Void
    ) {
        KevinAccountsApiClient.shared.getSupportedBanks(
            token: configuration.state,
            country: configuration.preselectedCountry?.rawValue
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
    ) -> UIViewController {
        let controller = KevinBankSelectionViewController()
        controller.configuration = KevinBankSelectionConfiguration(
            selectedCountry: configuration.preselectedCountry,
            isCountrySelectionDisabled: configuration.disableCountrySelection,
            countryFilter: configuration.countryFilter,
            selectedBankId: configuration.preselectedBank,
            authState: configuration.state,
            exitSlug: "dialog_exit_confirmation_accounts_message"
        )
        controller.onContinuation = { [weak self] bankId in
            controller.show(
                self!.initializeAccountLinkingConfirmationController(configuration: configuration, selectedBank: bankId),
                sender: nil
            )
        }
        return KevinNavigationViewController(rootViewController: controller)
    }
    
    //MARK: AccountLinkingConfirmation
    
    private func initializeAccountLinkingConfirmation(
        configuration: KevinAccountLinkingSessionConfiguration
    ) -> UIViewController {
        let controller = KevinAccountLinkingViewController()
        controller.configuration = KevinAccountLinkingConfiguration(
            state: configuration.state,
            selectedBankId: configuration.preselectedBank!
        )
        return KevinNavigationViewController(rootViewController: controller)
    }
    
    private func initializeAccountLinkingConfirmationController(
        configuration: KevinAccountLinkingSessionConfiguration,
        selectedBank: String? = nil
    ) -> UIViewController {
        let controller = KevinAccountLinkingViewController()
        controller.configuration = KevinAccountLinkingConfiguration(
            state: configuration.state,
            selectedBankId: selectedBank ?? configuration.preselectedBank!
        )
        return controller
    }
}
