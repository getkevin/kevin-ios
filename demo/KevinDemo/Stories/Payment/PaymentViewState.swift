//
//  MainActionState.swift
//  KevinDemo
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation
import SwiftUI
import RealmSwift

struct PaymentViewState {
    var isCountryLoading: Bool = false
    var isCharityLoading: Bool = false
    var isPaymentInProgress: Bool = false
    var countryCodes: [String] = []
    var selectedCountryCode: String?
    var isCountrySelectorPresented: Bool = false
    var charities: [ApiCharity] = []
    var selectedCharity: ApiCharity?
    var email: String = ""
    var amountString: String = ""
    var isAgreementChecked: Bool = false
    var isDonateButtonDisabled: Bool = true
    var openKevin: Bool = false
    var showMessage: Bool = false
    var messageTitle: String? = nil
    var messageDescription: String? = nil
    var isPaymentTypeSelectorPresented: Bool = false
    var isLinkedBankSelectorPresented: Bool = false
    var notificationToken: NotificationToken?
    var linkedBanks: Results<LinkedBank>?
}
