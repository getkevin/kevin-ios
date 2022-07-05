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
    var isCharityLoading = false
    var isPaymentInProgress = false
    var countryCodes: [String] = []
    var selectedCountryCode: String?
    var isCountrySelectorPresented = false
    var charities: [ApiCharity] = []
    var selectedCharity: ApiCharity?
    var email = ""
    var amount = 0.0
    var isAgreementChecked = false
    var openKevin = false
    var showMessage = false
    var messageTitle: String? = nil
    var messageDescription: String? = nil
    var isPaymentTypeSelectorPresented = false
    var isLinkedBankSelectorPresented = false
    var notificationToken: NotificationToken?
    var linkedBanks: Results<LinkedBank>?
}
