//
//  KevinErrors.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 08/09/2023.
//  Copyright © 2023 kevin.. All rights reserved.
//

import Foundation

internal class KevinErrors {
    static let accountPluginCallbackUrlNotConfigured = KevinError(description: "CallbackUrl in KevinAccountsPlugin was not configured!")
    static let accountPluginNotConfigured = KevinError(description: "KevinAccountsPlugin was not configured!")
    static let paymentPluginNotConfigured = KevinError(description: "KevinInAppPaymentsPlugin was not configured!")
    static let accountAuthCodeMissing = KevinError(description: "Account authorizationCode has not been returned!")
    static let preselectedBankNotSupported = KevinError(description: "Provided preselected bank is not supported")
    static let preselectedBankNotProvided = KevinError(description: "If skipBankSelection is true, preselectedBank must be provided!")
    static let filterInvalid = KevinError(description: "Provided bank filter does not contain supported banks")
    static let preselectedCountryNotProvided = KevinError(description: "If disableCountrySelection is true, preselectedCountry must be provided!")
    static let preselectedCountryNoInTheFilter = KevinError(description: "PreselectedCountry has to be included in countryFilter!")
    static let unknownPaymetnStatus = KevinError(description: "Unknown payment status received")

    static let linkingCanceled = KevinCancelationError(description: "Account linking was canceled!")
    static let paymentCanceled = KevinCancelationError(description: "Payment was canceled!")
    
    static func schemeNotInstalled(scheme: String?) -> KevinError {
        return KevinError(description: "\(scheme ?? "Unknown") is not installed")
    }
}
