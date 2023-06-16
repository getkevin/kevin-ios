//
//  KevinBankSelectionViewModel.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

protocol KevinBankSelectionViewModelDelegate: AnyObject {
    func didFailInitiatePayment(error: Error)
}

internal class KevinBankSelectionViewModel : KevinViewModel<KevinBankSelectionState, KevinBankSelectionIntent> {
    
    weak var delegate: KevinBankSelectionViewModelDelegate?
        
    override func offer(intent: KevinBankSelectionIntent) {
        switch intent {
        case .initialize(let configuration):
            initialize(configuration)
        }
    }
    
    private func initialize(_ configuration: KevinBankSelectionConfiguration) {
        let country = configuration.selectedCountry.rawValue
        onStateChanged(
            KevinBankSelectionState(
                selectedCountry: country,
                selectedBankId: nil,
                isCountrySelectionDisabled: configuration.isCountrySelectionDisabled,
                bankItems: [],
                isLoading: true
            )
        )
        loadBanksForCoutry(country, configuration: configuration)
    }
    
    private func loadBanksForCoutry(
        _ code: String,
        configuration: KevinBankSelectionConfiguration
    ) {
        KevinAccountsApiClient.shared.getSupportedBanks(
            token: configuration.authState,
            country: code
        ) { [weak self] bankItems, error in
            
            if let error {
                self?.delegate?.didFailInitiatePayment(error: error)
                return
            }
            
            guard let bankItems else { return }
            
            var filtredBankItems = bankItems
            let allowedBankIds = configuration.bankFilter.map { $0.uppercased() }
            
            if !allowedBankIds.isEmpty {
                filtredBankItems = filtredBankItems.filter { apiBank in
                    allowedBankIds.contains(apiBank.id.uppercased())
                }
            }
            
            if configuration.excludeBanksWithoutAccountLinkingSupport {
                filtredBankItems = filtredBankItems.filter { $0.isAccountLinkingSupported }
            }
            
            let newState = KevinBankSelectionState(
                selectedCountry: code,
                selectedBankId: configuration.selectedBankId ?? filtredBankItems.first?.id,
                isCountrySelectionDisabled: configuration.isCountrySelectionDisabled,
                bankItems: filtredBankItems,
                isLoading: false
            )
            
            self?.onStateChanged(newState)
        }
    }
}
