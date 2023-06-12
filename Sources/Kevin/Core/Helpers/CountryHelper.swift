//
//  Kevin.swift
//  kevin.iOS
//
//  Created by Kacper Dziubek on 12/06/2023.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation
import CoreTelephony

internal struct CountryHelper {
    static var defaultCountry: KevinCountry {
       let detected = [countryBasedOnSIM(), countryBasedOnLocale()]
            .compactMap { $0 }
            .first
        
        return detected ?? KevinCountry.lithuania
    }
    
    private static func countryBasedOnSIM() -> KevinCountry? {
        if #available(iOS 12.0, *) {
            let networkProviders = CTTelephonyNetworkInfo().serviceSubscriberCellularProviders
            let simCountryCodes = networkProviders?.compactMap { $0.value.isoCountryCode }
            guard
                let countryCode = simCountryCodes?.first,
                let kevinCountry = KevinCountry(rawValue: countryCode.lowercased())
            else {
                return nil
            }
            
            return kevinCountry
        } else {
            return nil
        }
    }
    
    private static func countryBasedOnLocale() -> KevinCountry? {
        guard let countryCode = (Locale.current as NSLocale).countryCode else {
            return nil
        }
        return KevinCountry(rawValue: countryCode.lowercased())
        
    }
}
