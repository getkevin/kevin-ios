//
//  KevinBankSelectionViewModel.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

internal class KevinBankSelectionViewModel : KevinViewModel<KevinBankSelectionState, KevinBankSelectionIntent> {
    
    override func offer(intent: KevinBankSelectionIntent) {
        if let intent = intent as? KevinBankSelectionIntent.Initialize {
            initialize(intent.configuration)
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
    
    private func loadBanksForCoutry(_ code: String, configuration: KevinBankSelectionConfiguration) {
        KevinAccountsApiClient.shared.getSupportedBanks(
            token: configuration.authState,
            country: code
        ) { [weak self] response, error in
            if let response = response {
                self?.onStateChanged(
                    KevinBankSelectionState(
                        selectedCountry: code,
                        selectedBankId: configuration.selectedBankId ?? response.first?.id,
                        isCountrySelectionDisabled: configuration.isCountrySelectionDisabled,
                        bankItems: response,
                        isLoading: false
                    )
                )
            }
        }
    }
}
