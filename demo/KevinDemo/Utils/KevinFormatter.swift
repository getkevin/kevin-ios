//
//  KevinFormatter.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 05/07/2022.
//

import Foundation

class KevinFormatter {
    class func getCurrencyFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.currencyCode = "EUR"
        formatter.currencySymbol = ""
        return formatter
    }
    
    class func getDecimalFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.groupingSeparator = ""
        return formatter
    }
}
