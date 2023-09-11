//
//  PaymentSessionConfigurationTests.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 08/09/2023.
//  Copyright © 2023 kevin.. All rights reserved.
//

import XCTest

@testable import Kevin

@MainActor final class PaymentSessionConfigurationTests: XCTestCase {
    
    let paymentIdMock = "paymentIdMock"
    
    func testAccountLinkingInitiationWithSkippingBankWithoutPreselectingBank() {
        XCTAssertThrowsError(
            try KevinPaymentSessionConfiguration.Builder(paymentId: paymentIdMock)
                .setSkipBankSelection(true)
                .build()
        ) { error in
            XCTAssertEqual(error as! KevinError, KevinErrors.preselectedBankNotProvided)
        }
    }
    
    func testAccountLinkingInitiationWithDisabledCountrySelectionWithoutPreselectingCountry() {
        XCTAssertThrowsError(
            try KevinPaymentSessionConfiguration.Builder(paymentId: paymentIdMock)
                .setDisableCountrySelection(true)
                .build()
        ) { error in
            XCTAssertEqual(error as! KevinError, KevinErrors.preselectedCountryNotProvided)
        }
    }
    
    func testAccountLinkingInitiationWithPreselectedCountryThatIsNotPartOfAFilter() {
        XCTAssertThrowsError(
            try KevinPaymentSessionConfiguration.Builder(paymentId: paymentIdMock)
                .setPreselectedCountry(KevinCountry.austria)
                .setCountryFilter([KevinCountry.belgium])
                .build()
        ) { error in
            XCTAssertEqual(error as! KevinError, KevinErrors.preselectedCountryNoInTheFilter)
        }
    }
}
