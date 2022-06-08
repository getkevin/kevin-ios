//
//  KevinBankSelectionState.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

internal struct KevinBankSelectionState : IKevinState {
    let selectedCountry: String
    let selectedBankId: String?
    let selectedCountryUnsupported: Bool
    let isCountrySelectionDisabled: Bool
    let bankItems: Array<ApiBank>
    let isLoading: Bool
}
