//
//  KevinCountrySelectionConfiguration.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

internal struct KevinCountrySelectionConfiguration {
    
    public let selectedCountry: String
    public let countryFilter: Array<KevinCountry>
    public let authState: String
    
    public init(
        selectedCountry: String,
        countryFilter: Array<KevinCountry>,
        authState: String
    ) {
        self.selectedCountry = selectedCountry
        self.countryFilter = countryFilter
        self.authState = authState
    }
}
