//
//  KevinCountrySelectionState.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

internal struct KevinCountrySelectionState : IKevinState {
    let selectedCountry: String
    let supportedCountries: Array<String>
    let isLoading: Bool
}
