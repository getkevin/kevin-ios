//
//  AccountLinkingViewState.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 13/06/2022.
//

import RealmSwift

public struct AccountLinkingViewState {
    var isLoading = false
    var notificationToken: NotificationToken?
    var linkedBanks: Results<LinkedBank>?
    var openKevin = false
    var showMessage = false
    var messageTitle: String? = nil
    var messageDescription: String? = nil
}
