//
//  KevinBankSelectionViewModelTests.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 11/09/2023.
//  Copyright © 2023 kevin.. All rights reserved.
//

import XCTest

@testable import Kevin

final class KevinBankSelectionViewModelTests: XCTestCase {
    
    let authStateMock = "authStateMock"
    
    var viewModel: KevinBankSelectionViewModel!
    var state: KevinBankSelectionState?
    var expectation: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
        
        KevinApiClient.shared.urlSession = mockURLSession
        
        MockURLProtocol.add(handler: MockRequestHandler(
            url: URL.banks(with: authStateMock).absoluteString + "?countryCode=lt",
            jsonResponse: banksResponse,
            customHandler: {
                // NOTE: Waiting 0.5 sec for API call to process by view model
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    self.expectation?.fulfill()
                    self.expectation = nil
                })
            }
        ))
        
        viewModel = KevinBankSelectionViewModel()
        viewModel.onStateChanged = { [weak self] state in
            self?.state = state
        }
    }
    
    override func tearDown() {
        super.tearDown()
        MockURLProtocol.clearHandlers()
    }
    
    func testViewModelInitiation() {
        // 1. Assign
        let selectedBankId = "INDUSTRA_LT"
        let selectedCoutnry = KevinCountry.lithuania
        let isCountrySelectionDisabled = true
        
        let configuration = KevinBankSelectionConfiguration(
            selectedCountry: selectedCoutnry,
            isCountrySelectionDisabled: isCountrySelectionDisabled,
            countryFilter: [],
            selectedBankId: selectedBankId,
            authState: authStateMock,
            exitSlug: "",
            bankFilter: [],
            excludeBanksWithoutAccountLinkingSupport: true,
            confirmInteractiveDismiss:.never
        )
        let intent = KevinBankSelectionIntent.initialize(configuration: configuration)
        
        expectation = expectation(description: "Banks are loaded")
        
        // 2. Act
        viewModel.offer(intent: intent)
        
        waitForExpectations(timeout: 0.5)
        
        // 3. Assert
        XCTAssertEqual(state?.isLoading, false)
        XCTAssertEqual(state?.selectedBankId, selectedBankId)
        XCTAssertEqual(state?.selectedCountry, selectedCoutnry.rawValue)
        XCTAssertEqual(state?.isCountrySelectionDisabled, true)
        XCTAssertEqual(state?.bankItems.count, 2)
    }
    
    func testViewModelInitiationWithBankFilter() {
        // 1. Assign
        let selectedBankId = "INDUSTRA_LT"
        let bankFilter = [
            "INDUSTRA_LT"
        ]
        let selectedCoutnry = KevinCountry.lithuania
        let isCountrySelectionDisabled = true
        
        let configuration = KevinBankSelectionConfiguration(
            selectedCountry: selectedCoutnry,
            isCountrySelectionDisabled: isCountrySelectionDisabled,
            countryFilter: [],
            selectedBankId: selectedBankId,
            authState: authStateMock,
            exitSlug: "",
            bankFilter: bankFilter,
            excludeBanksWithoutAccountLinkingSupport: true,
            confirmInteractiveDismiss:.never
        )
        let intent = KevinBankSelectionIntent.initialize(configuration: configuration)
        
        expectation = expectation(description: "Banks are loaded")
        
        // 2. Act
        viewModel.offer(intent: intent)
        
        waitForExpectations(timeout: 0.5)
        
        // 3. Assert
        XCTAssertEqual(state?.isLoading, false)
        XCTAssertEqual(state?.selectedBankId, selectedBankId)
        XCTAssertEqual(state?.selectedCountry, selectedCoutnry.rawValue)
        XCTAssertEqual(state?.isCountrySelectionDisabled, true)
        XCTAssertEqual(state?.bankItems.count, 1)
    }
    
    func testViewModelInitiationWithUnsuportedBanks() {
        // 1. Assign
        let selectedBankId = "INDUSTRA_LT"
        let selectedCoutnry = KevinCountry.lithuania
        let isCountrySelectionDisabled = false
        
        let configuration = KevinBankSelectionConfiguration(
            selectedCountry: selectedCoutnry,
            isCountrySelectionDisabled: isCountrySelectionDisabled,
            countryFilter: [],
            selectedBankId: selectedBankId,
            authState: authStateMock,
            exitSlug: "",
            bankFilter: [],
            excludeBanksWithoutAccountLinkingSupport: false,
            confirmInteractiveDismiss:.never
        )
        let intent = KevinBankSelectionIntent.initialize(configuration: configuration)
        
        expectation = expectation(description: "Banks are loaded")
        
        // 2. Act
        viewModel.offer(intent: intent)
        
        waitForExpectations(timeout: 0.5)
        
        // 3. Assert
        XCTAssertEqual(state?.isLoading, false)
        XCTAssertEqual(state?.selectedBankId, selectedBankId)
        XCTAssertEqual(state?.selectedCountry, selectedCoutnry.rawValue)
        XCTAssertEqual(state?.isCountrySelectionDisabled, false)
        XCTAssertEqual(state?.bankItems.count, 3)
    }
}

private let banksResponse = """
{
  "data": [
    {
      "id": "INDUSTRA_LT",
      "name": "Industra",
      "officialName": "AS Industra Bank Lietuvos filialas",
      "countryCode": "LT",
      "isSandbox": false,
      "imageUri": "https://cdn.kevin.eu/banks/images/INDUSTRA_LT.png",
      "bic": "MULTLT2X",
      "isBeta": false,
      "isAccountLinkingSupported": true
    },
    {
      "id": "REVOLUT_LT",
      "name": "Revolut",
      "officialName": "Revolut",
      "countryCode": "LT",
      "isSandbox": false,
      "imageUri": "https://cdn.kevin.eu/banks/images/REVOLUT_LT.png",
      "bic": "REVO",
      "isBeta": false,
      "isAccountLinkingSupported": true
    },
    {
      "id": "UNSUPORTED_BANK",
      "name": "Unsuported bank",
      "officialName": "Unsuported bank",
      "countryCode": "LT",
      "isSandbox": false,
      "imageUri": "",
      "bic": "UNSUPORTED",
      "isBeta": false,
      "isAccountLinkingSupported": false
    }
  ]
}
"""
