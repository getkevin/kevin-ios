//
//  LinkingSessionConfigurationTests.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 08/09/2023.
//  Copyright © 2023 kevin.. All rights reserved.
//

import XCTest

@testable import Kevin

@MainActor final class LinkingSessionConfigurationTests: XCTestCase {
    
    let authStateMock = "authStateMock"
    
    func testAccountLinkingInitiationWithSkippingBankWithoutPreselectingBank() {
        XCTAssertThrowsError(
            try KevinAccountLinkingSessionConfiguration.Builder(state: authStateMock)
                .setSkipBankSelection(true)
                .build()
        ) { error in
            XCTAssertEqual(error as! KevinError, KevinErrors.preselectedBankNotProvided)
        }
    }

    func testAccountLinkingInitiationWithDisabledCountrySelectionWithoutPreselectingCountry() {
        XCTAssertThrowsError(
            try KevinAccountLinkingSessionConfiguration.Builder(state: authStateMock)
                .setDisableCountrySelection(true)
                .build()
        ) { error in
            XCTAssertEqual(error as! KevinError, KevinErrors.preselectedCountryNotProvided)
        }
    }

    func testAccountLinkingInitiationWithPreselectedCountryThatIsNotPartOfAFilter() {
        XCTAssertThrowsError(
            try KevinAccountLinkingSessionConfiguration.Builder(state: authStateMock)
                .setPreselectedCountry(KevinCountry.austria)
                .setCountryFilter([KevinCountry.belgium])
                .build()
        ) { error in
            XCTAssertEqual(error as! KevinError, KevinErrors.preselectedCountryNoInTheFilter)
        }
    }
}
