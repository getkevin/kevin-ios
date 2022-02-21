//
//  MainActionState.swift
//  KevinDemo
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation
import SwiftUI

struct MainViewState {
    var isCountryLoading: Bool = false
    var isCharityLoading: Bool = false
    var isPaymentInProgress: Bool = false
    var selectedPaymentType: PaymentType = PaymentType.bank
    var isCountrySelectorPresented: Bool = false
    var countryCodes: [String] = []
    var selectedCountryCode: String?
    var charities: [ApiCharity] = []
    var selectedCharity: ApiCharity? 
    var email: String = ""
    var amountString: String = "0.00"
    var isAgreementChecked: Bool = false
    var isDonateButtonDisabled: Bool = true
    var openKevin: Bool = false
    var showMessage: Bool = false
    var messageTitle: String? = nil
    var messageDescription: String? = nil
}
