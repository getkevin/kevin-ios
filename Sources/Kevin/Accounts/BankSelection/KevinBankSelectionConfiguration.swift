//
//  KevinBankSelectionConfiguration.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

internal struct KevinBankSelectionConfiguration {
    
    public var selectedCountry: KevinCountry
    public let isCountrySelectionDisabled: Bool
    public let countryFilter: Array<KevinCountry>
    public let selectedBankId: String?
    public let authState: String
    public let exitSlug: String
    public let showOnlyAccountLinkingSupportedBanks: Bool
    
    public init(
        selectedCountry: KevinCountry,
        isCountrySelectionDisabled: Bool,
        countryFilter: Array<KevinCountry>,
        selectedBankId: String?,
        authState: String,
        exitSlug: String,
        showOnlyAccountLinkingSupportedBanks: Bool
    ) {
        self.selectedCountry = selectedCountry
        self.isCountrySelectionDisabled = isCountrySelectionDisabled
        self.countryFilter = countryFilter
        self.selectedBankId = selectedBankId
        self.authState = authState
        self.exitSlug = exitSlug
        self.showOnlyAccountLinkingSupportedBanks = showOnlyAccountLinkingSupportedBanks
    }
}
