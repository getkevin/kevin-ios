//
//  KevinAccountLinkingSessionConfiguration.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

/// Account linking session configuration class
public class KevinAccountLinkingSessionConfiguration {
    
    let state: String
    let preselectedCountry: KevinCountry?
    let disableCountrySelection: Bool
    let countryFilter: Array<KevinCountry>
    let preselectedBank: String?
    let skipBankSelection: Bool
    
    init(
        state: String,
        preselectedCountry: KevinCountry?,
        disableCountrySelection: Bool,
        countryFilter: Array<KevinCountry>,
        preselectedBank: String?,
        skipBankSelection: Bool
    ) throws {
        self.state = state
        self.preselectedCountry = preselectedCountry
        self.disableCountrySelection = disableCountrySelection
        self.countryFilter = countryFilter
        self.preselectedBank = preselectedBank
        self.skipBankSelection = skipBankSelection
        
        if skipBankSelection && preselectedBank == nil {
            throw KevinError(description: "If skipBankSelection is true, preselectedBank must be provided!")
        }
        if disableCountrySelection && preselectedCountry == nil {
            throw KevinError(description: "If disableCountrySelection is true, preselectedCountry must be provided!")
        }
        if let preselectedCountry = preselectedCountry, !countryFilter.isEmpty {
            if !countryFilter.contains(preselectedCountry) {
                throw KevinError(description: "PreselectedCountry has to be included in countryFilter!")
            }
        }
    }
    
    public class Builder {
        
        private let state: String
        private var preselectedCountry: KevinCountry? = nil
        private var disableCountrySelection: Bool = false
        private var countryFilter: Array<KevinCountry> = []
        private var preselectedBank: String? = nil
        private var skipBankSelection: Bool = false
        
        /// Creates an instance with the given state.
        ///
        /// - Parameters:
        ///   - state: authentication state value
        public init(state: String) {
            self.state = state
        }
        
        /// Sets a default country
        ///
        /// - Parameters:
        ///   - country: desired default country
        public func setPreselectedCountry(_ country: KevinCountry?) -> Builder {
            self.preselectedCountry = country
            return self
        }
        
        /// Disables country selection
        ///
        /// - Parameters:
        ///   - isDisabled: disable country change if set to true
        public func setDisableCountrySelection(_ isDisabled: Bool) -> Builder {
            self.disableCountrySelection = isDisabled
            return self
        }
        
        /// Sets country filter
        ///
        /// - Parameters:
        ///   - countries: only countries in the filter will be displayed
        ///     in country selection
        public func setCountryFilter(_ countries: Array<KevinCountry?>) -> Builder {
            self.countryFilter = countries.compactMap { $0 }
            return self
        }
        
        /// Preselects desired bank
        ///
        /// - Parameters:
        ///   - bank: desired default bank in the bank selection
        public func setPreselectedBank(_ bank: String) -> Builder {
            self.preselectedBank = bank
            return self
        }
        
        /// Skips bank selection if set to true
        ///
        /// - Parameters:
        ///   - skip: if set to true, then skips bank selection view.
        ///     Preselected bank is mandatory.
        public func setSkipBankSelection(_ skip: Bool) -> Builder {
            self.skipBankSelection = skip
            return self
        }
        
        public func build() throws -> KevinAccountLinkingSessionConfiguration {
            return try KevinAccountLinkingSessionConfiguration(
                state: state,
                preselectedCountry: preselectedCountry,
                disableCountrySelection: disableCountrySelection,
                countryFilter: countryFilter,
                preselectedBank: preselectedBank,
                skipBankSelection: skipBankSelection
            )
        }
    }
}
