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
    let bankFilter: [String]
    let preselectedBank: String?
    let skipBankSelection: Bool
    let linkingType: KevinAccountLinkingType
    let confirmInteractiveDismiss: KevinConfirmInteractiveDismissType
    
    init(
        state: String,
        preselectedCountry: KevinCountry?,
        disableCountrySelection: Bool,
        countryFilter: Array<KevinCountry>,
        bankFilter: [String],
        preselectedBank: String?,
        skipBankSelection: Bool,
        linkingType: KevinAccountLinkingType,
        confirmInteractiveDismiss: KevinConfirmInteractiveDismissType
    ) throws {
        self.state = state
        self.preselectedCountry = preselectedCountry
        self.disableCountrySelection = disableCountrySelection
        self.countryFilter = countryFilter
        self.bankFilter = bankFilter
        self.preselectedBank = preselectedBank
        self.skipBankSelection = skipBankSelection
        self.linkingType = linkingType
        self.confirmInteractiveDismiss = confirmInteractiveDismiss

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
        private var bankFilter = [String]()
        private var preselectedBank: String? = nil
        private var skipBankSelection: Bool = false
        private var linkingType: KevinAccountLinkingType = .bank
        private var confirmInteractiveDismiss: KevinConfirmInteractiveDismissType = .always
        
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
        
        /// Allows to filter banks and show only selected ones to user. It accepts list of bank ids that should be show to user.
        /// - Parameters:
        ///    - bankFilter: bank ids that should be show to user
        
        public func setBankFilter(_ bankFilter: [String]) -> Builder {
            self.bankFilter = bankFilter
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
        
        /// Sets linking type
        ///
        /// - Parameters:
        ///   - type: desired linking type.
        @available(*, deprecated, message: "This method will be removed in the future versions of the SDK. You can safely remove it from your configuration.")
        public func setLinkingType(_ type: KevinAccountLinkingType) -> Builder {
            self.linkingType = type
            return self
        }

        /// Allows to display an alert confirmation on an attempt to interactively (by swipe) dismiss the SDK navigation controller.
        ///
        /// Possible options to use:
        ///  - `.never` - will never ask for confirmation
        ///  - `.always` - (default) will always ask for confirmation
        ///
        /// - Parameters:
        ///   - type: KevinConfirmInteractiveDismissType.
        public func setConfirmInteractiveDismiss(_ type: KevinConfirmInteractiveDismissType) -> Builder {
            self.confirmInteractiveDismiss = type
            return self
        }

        public func build() throws -> KevinAccountLinkingSessionConfiguration {
            return try KevinAccountLinkingSessionConfiguration(
                state: state,
                preselectedCountry: preselectedCountry,
                disableCountrySelection: disableCountrySelection,
                countryFilter: countryFilter,
                bankFilter: bankFilter,
                preselectedBank: preselectedBank,
                skipBankSelection: skipBankSelection,
                linkingType: linkingType,
                confirmInteractiveDismiss: confirmInteractiveDismiss
            )
        }
    }
}
