//
//  PaymentType.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 15/02/2022.
//

import Foundation
import SwiftUI

enum PaymentType: Int, CaseIterable {
    case bank
    case linkedBank
    case card
}

extension PaymentType {
    var icon: Image {
        switch self {
        case .bank:
            return Image("BankPayment")
        case .linkedBank:
            return Image("LinkedBankPayment")
        case .card:
            return Image("CardPayment")
        }
    }
    
    var title: String {
        switch self {
        case .bank:
            return "kevin_window_payment_type_bank".localized()
        case .linkedBank:
            return "kevin_window_payment_type_linked".localized()
        case .card:
            return "kevin_window_payment_type_card".localized()
        }
    }
}
