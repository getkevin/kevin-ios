//
//  KevinAccountLinkingViewModelTests.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 11/09/2023.
//  Copyright © 2023 kevin.. All rights reserved.
//

import XCTest

@testable import Kevin

final class KevinAccountLinkingViewModelTests: XCTestCase {
    
    let authStateMock = "authStateMock"
    let redirectURLMock = "https://redirectURLMock.test/authorization.html"
    
    var viewModel: KevinAccountLinkingViewModel!
    var state: KevinAccountLinkingState?
    
    var expectation: XCTestExpectation?
    var controller: UINavigationController?
    var error: Error?
    var authorizationCode: String?
    var bank: ApiBank?
    
    override func setUp() {
        super.setUp()

        // MARK: Set up networking mock
        KevinApiClient.shared.urlSession = mockURLSession
        MockURLProtocol.add(handler: MockRequestHandler(
            url: URL.banks(with: authStateMock).absoluteString,
            jsonResponse: banksResponse
        ))
        MockURLProtocol.add(handler: MockRequestHandler(
            url: URL.banks(with: authStateMock).absoluteString + "?countryCode=lt",
            jsonResponse: banksResponse
        ))
        
        // MARK: Set up SDK
        let configurationAccounts = KevinAccountsConfiguration.Builder(
            callbackUrl: URL(string: redirectURLMock)!
        ).build()
        KevinAccountsPlugin.shared.configure(configurationAccounts)
        
        // MARK: Set up view model
        viewModel = KevinAccountLinkingViewModel()
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
        
        let configuration = KevinAccountLinkingConfiguration(
            state: authStateMock,
            selectedBankId: selectedBankId,
            selectedCountry: selectedCoutnry,
            linkingType: .bank
        )
        let intent = KevinAccountLinkingIntent.Initialize(configuration: configuration)
        
        let expectedBaseUrl = String(format: KevinApiPaths.bankLinkingUrl, authStateMock, selectedBankId)
        
        // 2. Act
        viewModel.offer(intent: intent)
        
        // 3. Assert
        XCTAssertEqual(state?.accountLinkingType, .bank)
        XCTAssertEqual(state?.bankRedirectUrl.absoluteString.contains(expectedBaseUrl), true)
    }
    
    func testViewModelLinkingCompletion() throws {
        // 1. Assign
        KevinAccountLinkingSession.shared.delegate = self
        let sdkConfiguration = try KevinAccountLinkingSessionConfiguration.Builder(state: authStateMock)
            .build()
                
        let selectedBankId = "INDUSTRA_LT"
        let selectedCoutnry = KevinCountry.lithuania

        let configuration = KevinAccountLinkingConfiguration(
            state: authStateMock,
            selectedBankId: selectedBankId,
            selectedCountry: selectedCoutnry,
            linkingType: .bank
        )
        
        let viewModelInitiationIntent = KevinAccountLinkingIntent.Initialize(configuration: configuration)
        
        let url = URL(string: "\(redirectURLMock)/?requestId=REQUEST_ID&status=success&code=\(authStateMock)")
        let linkingCompletionIntent = KevinAccountLinkingIntent.HandleLinkingCompleted(
            url: url,
            error: nil,
            configuration: configuration
        )
        
        // 2. Act
        expectation = expectation(description: "Account linking initiates")
        KevinAccountLinkingSession.shared.initiateAccountLinking(configuration: sdkConfiguration)
        waitForExpectations(timeout: 0.1)

        expectation = expectation(description: "Account linking completed")
        viewModel.offer(intent: viewModelInitiationIntent)
        viewModel.offer(intent: linkingCompletionIntent)
        waitForExpectations(timeout: 0.1)

        // 3. Assert
        let resultAuthorizationCode = try XCTUnwrap(authorizationCode)
        let resultBank = try XCTUnwrap(bank)
        
        XCTAssertEqual(resultAuthorizationCode, authStateMock)
        XCTAssertEqual(resultBank.id, selectedBankId)
    }
    
    func testViewModelLinkingCompletionWithMissingCode() throws {
        // 1. Assign
        KevinAccountLinkingSession.shared.delegate = self
        let sdkConfiguration = try KevinAccountLinkingSessionConfiguration.Builder(state: authStateMock)
            .build()
                
        let selectedBankId = "INDUSTRA_LT"
        let selectedCoutnry = KevinCountry.lithuania

        let configuration = KevinAccountLinkingConfiguration(
            state: authStateMock,
            selectedBankId: selectedBankId,
            selectedCountry: selectedCoutnry,
            linkingType: .bank
        )
        
        let viewModelInitiationIntent = KevinAccountLinkingIntent.Initialize(configuration: configuration)
        
        let url = URL(string: "\(redirectURLMock)/?requestId=REQUEST_ID&status=success")
        let linkingCompletionIntent = KevinAccountLinkingIntent.HandleLinkingCompleted(
            url: url,
            error: nil,
            configuration: configuration
        )
        
        // 2. Act
        expectation = expectation(description: "Account linking initiates")
        KevinAccountLinkingSession.shared.initiateAccountLinking(configuration: sdkConfiguration)
        waitForExpectations(timeout: 0.1)

        expectation = expectation(description: "Account linking completed")
        viewModel.offer(intent: viewModelInitiationIntent)
        viewModel.offer(intent: linkingCompletionIntent)
        waitForExpectations(timeout: 0.1)

        // 3. Assert
        let resultError = try XCTUnwrap(error) as? KevinError
        
        XCTAssertEqual(resultError, KevinErrors.accountAuthCodeMissing)
    }
    
    func testViewModelLinkingCompletionWithMissingStatus() throws {
        // 1. Assign
        KevinAccountLinkingSession.shared.delegate = self
        let sdkConfiguration = try KevinAccountLinkingSessionConfiguration.Builder(state: authStateMock)
            .build()
                
        let selectedBankId = "INDUSTRA_LT"
        let selectedCoutnry = KevinCountry.lithuania

        let configuration = KevinAccountLinkingConfiguration(
            state: authStateMock,
            selectedBankId: selectedBankId,
            selectedCountry: selectedCoutnry,
            linkingType: .bank
        )
        
        let viewModelInitiationIntent = KevinAccountLinkingIntent.Initialize(configuration: configuration)
        
        let url = URL(string: "\(redirectURLMock)/?requestId=REQUEST_ID&code=\(authStateMock)")
        let linkingCompletionIntent = KevinAccountLinkingIntent.HandleLinkingCompleted(
            url: url,
            error: nil,
            configuration: configuration
        )
        
        // 2. Act
        expectation = expectation(description: "Account linking initiates")
        KevinAccountLinkingSession.shared.initiateAccountLinking(configuration: sdkConfiguration)
        waitForExpectations(timeout: 0.1)

        expectation = expectation(description: "Account linking completed")
        viewModel.offer(intent: viewModelInitiationIntent)
        viewModel.offer(intent: linkingCompletionIntent)
        waitForExpectations(timeout: 0.1)

        // 3. Assert
        let resultError = try XCTUnwrap(error) as? KevinError
        
        XCTAssertEqual(resultError, KevinErrors.unknownLinkingStatus)
    }
    
    func testViewModelLinkingCompletionWithFailedStatus() throws {
        // 1. Assign
        KevinAccountLinkingSession.shared.delegate = self
        let sdkConfiguration = try KevinAccountLinkingSessionConfiguration.Builder(state: authStateMock)
            .build()
                
        let selectedBankId = "INDUSTRA_LT"
        let selectedCoutnry = KevinCountry.lithuania

        let configuration = KevinAccountLinkingConfiguration(
            state: authStateMock,
            selectedBankId: selectedBankId,
            selectedCountry: selectedCoutnry,
            linkingType: .bank
        )
        
        let viewModelInitiationIntent = KevinAccountLinkingIntent.Initialize(configuration: configuration)
        
        let url = URL(string: "\(redirectURLMock)/?requestId=REQUEST_ID&status=failed&code=\(authStateMock)")
        let linkingCompletionIntent = KevinAccountLinkingIntent.HandleLinkingCompleted(
            url: url,
            error: nil,
            configuration: configuration
        )
        
        // 2. Act
        expectation = expectation(description: "Account linking initiates")
        KevinAccountLinkingSession.shared.initiateAccountLinking(configuration: sdkConfiguration)
        waitForExpectations(timeout: 0.1)

        expectation = expectation(description: "Account linking completed")
        viewModel.offer(intent: viewModelInitiationIntent)
        viewModel.offer(intent: linkingCompletionIntent)
        waitForExpectations(timeout: 0.1)

        // 3. Assert
        let resultError = try XCTUnwrap(error) as? KevinError
        
        XCTAssertEqual(resultError, KevinErrors.linkingCanceled)
    }
    
    func testViewModelLinkingCompletionWithError() throws {
        // 1. Assign
        KevinAccountLinkingSession.shared.delegate = self
        let sdkConfiguration = try KevinAccountLinkingSessionConfiguration.Builder(state: authStateMock)
            .build()
                
        let selectedBankId = "INDUSTRA_LT"
        let selectedCoutnry = KevinCountry.lithuania

        let configuration = KevinAccountLinkingConfiguration(
            state: authStateMock,
            selectedBankId: selectedBankId,
            selectedCountry: selectedCoutnry,
            linkingType: .bank
        )
        
        let viewModelInitiationIntent = KevinAccountLinkingIntent.Initialize(configuration: configuration)
        
        let error = KevinError(description: "Custom test error")
        let linkingCompletionIntent = KevinAccountLinkingIntent.HandleLinkingCompleted(
            url: nil,
            error: error,
            configuration: configuration
        )
        
        // 2. Act
        expectation = expectation(description: "Account linking initiates")
        KevinAccountLinkingSession.shared.initiateAccountLinking(configuration: sdkConfiguration)
        waitForExpectations(timeout: 0.1)

        expectation = expectation(description: "Account linking completed")
        viewModel.offer(intent: viewModelInitiationIntent)
        viewModel.offer(intent: linkingCompletionIntent)
        waitForExpectations(timeout: 0.1)

        // 3. Assert
        let resultError = try XCTUnwrap(error)
        
        XCTAssertEqual(resultError, error)
    }
}

extension KevinAccountLinkingViewModelTests: KevinAccountLinkingSessionDelegate {
    
    func onKevinAccountLinkingStarted(controller: UINavigationController) {
        self.controller = controller
        expectation?.fulfill()
        expectation = nil
    }
    
    func onKevinAccountLinkingCanceled(error: Error?) {
        self.error = error
        expectation?.fulfill()
        expectation = nil
    }
    
    func onKevinAccountLinkingSucceeded(authorizationCode: String, bank: ApiBank?, linkingType: KevinAccountLinkingType) {
        self.authorizationCode = authorizationCode
        self.bank = bank
        expectation?.fulfill()
        expectation = nil
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
    }
  ]
}
"""
