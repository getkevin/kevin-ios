//
//  KevinCountrySelectionViewModelTests.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 11/09/2023.
//  Copyright © 2023 kevin.. All rights reserved.
//

import XCTest

@testable import Kevin

final class KevinCountrySelectionViewModelTests: XCTestCase {
    
    let authStateMock = "authStateMock"
    
    var viewModel: KevinCountrySelectionViewModel!
    var state: KevinCountrySelectionState?
    var expectation: XCTestExpectation?

    override func setUp() {
        super.setUp()
        
        KevinApiClient.shared.urlSession = mockURLSession
        
        MockURLProtocol.add(handler: MockRequestHandler(
            url: URL.countries(with: authStateMock).absoluteString,
            jsonResponse: countriesResponse,
            customHandler: {
                // NOTE: Waiting 0.5 sec for API call to process by view model
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    self.expectation?.fulfill()
                    self.expectation = nil
                })
            }
        ))

        viewModel = KevinCountrySelectionViewModel()
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
        let selectedCoutnry = KevinCountry.lithuania
        
        let configuration = KevinCountrySelectionConfiguration(
            selectedCountry: selectedCoutnry.rawValue,
            countryFilter: [],
            authState: authStateMock
        )
        let intent = KevinCountrySelectionIntent.Initialize(configuration: configuration)
        
        expectation = expectation(description: "Countries are loaded")
        
        // 2. Act
        viewModel.offer(intent: intent)
        
        waitForExpectations(timeout: 0.5)

        // 3. Assert
        XCTAssertEqual(state?.isLoading, false)
        XCTAssertEqual(state?.selectedCountry, selectedCoutnry.rawValue)
        XCTAssertEqual(state?.supportedCountries.count, 3)
    }
    
    func testViewModelInitiationWithCountryFilter() {
        // 1. Assign
        let selectedCoutnry = KevinCountry.lithuania
        let countryFilter = [
            KevinCountry.lithuania,
            KevinCountry.latvia
        ]
        
        let configuration = KevinCountrySelectionConfiguration(
            selectedCountry: selectedCoutnry.rawValue,
            countryFilter: countryFilter,
            authState: authStateMock
        )
        let intent = KevinCountrySelectionIntent.Initialize(configuration: configuration)
        
        expectation = expectation(description: "Countries are loaded")

        // 2. Act
        viewModel.offer(intent: intent)
        
        waitForExpectations(timeout: 0.5)

        // 3. Assert
        XCTAssertEqual(state?.isLoading, false)
        XCTAssertEqual(state?.selectedCountry, selectedCoutnry.rawValue)
        XCTAssertEqual(state?.supportedCountries.count, 2)
    }
}

private let countriesResponse = """
{
  "data": [
    "lv",
    "lt",
    "ee"
  ]
}
"""
