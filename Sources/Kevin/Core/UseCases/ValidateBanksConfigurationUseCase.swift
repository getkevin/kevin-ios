//
//  ValidateBanksConfigurationUseCase.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 15/06/2023.
//  Copyright © 2023 kevin.. All rights reserved.
//

import Foundation

enum BankConfigurationValidationStatus: Equatable {
    case valid(selectedBank: ApiBank?)
    case invalidFilter
    case invalidPreselectedBank
    case unknown(error: Error)
    
    static func == (lhs: BankConfigurationValidationStatus, rhs: BankConfigurationValidationStatus) -> Bool {
        switch (lhs, rhs) {
        case (.valid(let lhsType), .valid(let rhsType)):
            return lhsType?.id == rhsType?.id
            
        case (.invalidFilter, .invalidFilter):
            return true
            
        case (.invalidPreselectedBank, .invalidPreselectedBank):
            return true
            
        case (.unknown(let lhsType), .unknown(let rhsType)):
            return lhsType.localizedDescription == rhsType.localizedDescription
            
        default:
            return false
        }
    }
}

class ValidateBanksConfigurationUseCase {
    
    enum Status {
        case valid(selectedBank: ApiBank?)
        case invalidFilter
        case invalidPreselectedBank
        case unknown(error: Error)
    }
    
    func validate(
        token: String,
        country: KevinCountry?,
        preselectedBank: String?,
        bankFilter: [String],
        shouldExcludeBanksWithoutAccountLinkingSupport: Bool,
        completion: @escaping (BankConfigurationValidationStatus) -> Void
    ) {
        KevinAccountsApiClient.shared.getSupportedBanks(
            token: token,
            country: country?.rawValue
        ) { bankItems, error in
            var selectedBank: ApiBank?
            
            if let error {
                completion(.unknown(error: error))
            }

            if let bankItems = bankItems {
                var filtredBankItems = bankItems

                if shouldExcludeBanksWithoutAccountLinkingSupport {
                    filtredBankItems = filtredBankItems
                        .filter { $0.isAccountLinkingSupported }
                }

                if !bankFilter.isEmpty {
                    filtredBankItems = filtredBankItems.filter { apiBank in
                        bankFilter
                            .map{ $0.uppercased() }
                            .contains(apiBank.id.uppercased())
                    }
                    
                    if filtredBankItems.isEmpty {
                        completion(.invalidFilter)
                    }
                }
                
                if let preselectedBank, !preselectedBank.isEmpty {
                    selectedBank = filtredBankItems.first(where: {
                        $0.id == preselectedBank
                    })
                    
                    if selectedBank == nil {
                        completion(.invalidPreselectedBank)
                    }
                }
            }
            
            completion(.valid(selectedBank: selectedBank))
        }
    }
}
