//
//  KevinCountrySelectionViewModel.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

internal class KevinCountrySelectionViewModel : KevinViewModel<KevinCountrySelectionState, KevinCountrySelectionIntent> {
    
    override func offer(intent: KevinCountrySelectionIntent) {
        if let intent = intent as? KevinCountrySelectionIntent.Initialize {
            initialize(intent.configuration)
        }
    }
    
    private func initialize(_ configuration: KevinCountrySelectionConfiguration) {
        onStateChanged(
            KevinCountrySelectionState(
                selectedCountry: configuration.selectedCountry,
                supportedCountries: [],
                isLoading: true
            )
        )
        loadCountries(configuration: configuration)
    }
    
    private func loadCountries(configuration: KevinCountrySelectionConfiguration) {
        KevinAccountsApiClient.shared.getSupportedCountries(
            token: configuration.authState
        ) { [weak self] response, error in
            if let response = response {
                let countryFilter = configuration.countryFilter.map { $0.rawValue.uppercased() }
                var supportedCountries: Array<String>!
                if !countryFilter.isEmpty {
                    supportedCountries = response.filter { countryFilter.contains($0.uppercased()) }
                } else {
                    supportedCountries = response
                }
                self?.onStateChanged(
                    KevinCountrySelectionState(
                        selectedCountry: configuration.selectedCountry,
                        supportedCountries: self?.getSortedSupportedCountries(codes: supportedCountries) ?? [],
                        isLoading: false
                    )
                )
            }
        }
    }
    
    private func getSortedSupportedCountries(codes: Array<String>) -> Array<String> {
        return codes.sorted {
            getLocalisedCountry(code: $0) < getLocalisedCountry(code: $1)
        }
    }
    
    private func getLocalisedCountry(code: String) -> String {
        return "country_name_\(code.lowercased())".localized(for: Kevin.shared.locale.identifier)
    }
}
