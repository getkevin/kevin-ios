//
//  LinkingSessionTests.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 05/09/2023.
//  Copyright © 2023 kevin.. All rights reserved.
//

import XCTest

@testable import Kevin

final class LinkingSessionTests: XCTestCase {
    
    let authStateMock = "authStateMock"
    let redirectURLMock = "https://redirectURLMock.test/authorization.html"
    
    var expectation: XCTestExpectation?
    var controller: UINavigationController?
    var error: Error?
    var authorizationCode: String?
    var bank: ApiBank?
    
    override func setUp() {
        super.setUp()
        
        KevinApiClient.shared.urlSession = mockURLSession
        
        let configurationAccounts = KevinAccountsConfiguration.Builder(
            callbackUrl: URL(string: redirectURLMock)!
        ).build()
        KevinAccountsPlugin.shared.configure(configurationAccounts)
        KevinAccountLinkingSession.shared.delegate = self

        MockURLProtocol.add(handler: MockRequestHandler(
            url: URL.banks(with: authStateMock).absoluteString,
            jsonResponse: banksResponse
        ))
    }
    
    override func tearDown() {
        super.tearDown()
        MockURLProtocol.clearHandlers()
    }

    // MARK: - Initiation
    
    func testAccountLinkingInitiationWithBankSelectionView() throws {
        // 1. Assign
        let configuration = try KevinAccountLinkingSessionConfiguration.Builder(state: authStateMock)
            .build()

        // 2. Act
        expectation = expectation(description: "Account linking initiates")
        KevinAccountLinkingSession.shared.initiateAccountLinking(configuration: configuration)

        waitForExpectations(timeout: 0.1)

        // 3. Assert
        let resultVC = try XCTUnwrap(controller)
        let resultBankSelectionViewController = resultVC.topViewController as? KevinBankSelectionViewController
        
        XCTAssertNotNil(resultBankSelectionViewController)
        XCTAssertNil(resultBankSelectionViewController?.configuration.selectedBankId)
    }
    
    func testAccountLinkingInitiationWithBankSelectionViewWithPreselectedBank() throws {
        // 1. Assign
        let preselectedBankId = "INDUSTRA_LT"
        let configuration = try KevinAccountLinkingSessionConfiguration.Builder(state: authStateMock)
            .setPreselectedBank(preselectedBankId)
            .build()

        // 2. Act
        expectation = expectation(description: "Account linking initiates")
        KevinAccountLinkingSession.shared.initiateAccountLinking(configuration: configuration)

        waitForExpectations(timeout: 0.1)

        // 3. Assert
        let resultVC = try XCTUnwrap(controller)
        let resultBankSelectionViewController = resultVC.topViewController as? KevinBankSelectionViewController
        
        XCTAssertNotNil(resultBankSelectionViewController)
        XCTAssertEqual(resultBankSelectionViewController?.configuration.selectedBankId, preselectedBankId)
    }
    

    func testAccountLinkingInitiationWithAccountLinkingConfirmationView() throws {
        // 1. Assign
        let configuration = try KevinAccountLinkingSessionConfiguration.Builder(state: authStateMock)
            .setPreselectedBank("INDUSTRA_LT")
            .setSkipBankSelection(true)
            .build()

        // 2. Act
        expectation = expectation(description: "Account linking initiates")
        KevinAccountLinkingSession.shared.initiateAccountLinking(configuration: configuration)

        waitForExpectations(timeout: 0.1)

        // 3. Assert
        let resultVC = try XCTUnwrap(controller)
        XCTAssert(resultVC.topViewController is KevinAccountLinkingViewController)
    }
    
    func testAccountLinkingInitiationWithErrorPreselectedBankIncorrect() throws {
        // 1. Assign
        let configuration = try KevinAccountLinkingSessionConfiguration.Builder(state: authStateMock)
            .setPreselectedBank("UNAVAILABLE_BANK")
            .build()

        // 2. Act
        expectation = expectation(description: "Account linking initiates")
        KevinAccountLinkingSession.shared.initiateAccountLinking(configuration: configuration)

        waitForExpectations(timeout: 0.1)

        // 3. Assert
        let resultError = try XCTUnwrap(error) as? KevinError
        XCTAssertEqual(resultError, KevinErrors.preselectedBankNotSupported)
    }
    
    func testAccountLinkingInitiationWithErrorBankFilterIncorrect() throws {
        // 1. Assign
        let configuration = try KevinAccountLinkingSessionConfiguration.Builder(state: authStateMock)
            .setBankFilter(["UNAVAILABLE_BANK"])
            .build()

        // 2. Act
        expectation = expectation(description: "Account linking initiates")
        KevinAccountLinkingSession.shared.initiateAccountLinking(configuration: configuration)

        waitForExpectations(timeout: 0.1)

        // 3. Assert
        let resultError = try XCTUnwrap(error) as? KevinError
        XCTAssertEqual(resultError, KevinErrors.filterInvalid)
    }
    
    func testAccountLinkingInitiationWithNetworkError() throws {
        // 1. Assign
        let configuration = try KevinAccountLinkingSessionConfiguration.Builder(state: authStateMock)
            .build()

        MockURLProtocol.clearHandlers()
        MockURLProtocol.add(handler: MockRequestHandler(
            url: URL.banks(with: authStateMock).absoluteString,
            statusCode: 404
        ))

        // 2. Act
        expectation = expectation(description: "Account linking initiates")
        KevinAccountLinkingSession.shared.initiateAccountLinking(configuration: configuration)

        waitForExpectations(timeout: 0.1)

        // 3. Assert
        let resultError = try XCTUnwrap(error)
        let resultApiError = resultError as? KevinApiError

        XCTAssertNotNil(resultApiError)
    }
    
    // MARK: - Cancelation
    
    func testLinkingCancelationOnBankSelectionView() throws {
        // 1. Assign
        let configuration = try KevinAccountLinkingSessionConfiguration.Builder(state: authStateMock)
            .build()

        // 2. Act
        expectation = expectation(description: "Account linking initiates")
        KevinAccountLinkingSession.shared.initiateAccountLinking(configuration: configuration)
        
        waitForExpectations(timeout: 0.1)
        
        let resultVC = try XCTUnwrap(controller)
        let resultBankSelectionViewController = resultVC.topViewController as? KevinBankSelectionViewController
        
        expectation = expectation(description: "Account linking cancelled")
        resultBankSelectionViewController?.onExit?()
        
        waitForExpectations(timeout: 0.1)

        // 3. Assert
        let resultError = try XCTUnwrap(error)
        let resultCancelationError = resultError as? KevinCancelationError

        XCTAssertNotNil(resultCancelationError)
    }
    
    func testLinkingCancelationOnAccountLinkingConfirmationView() throws {
        // 1. Assign
        let configuration = try KevinAccountLinkingSessionConfiguration.Builder(state: authStateMock)
            .setPreselectedBank("INDUSTRA_LT")
            .setSkipBankSelection(true)
            .build()

        // 2. Act
        expectation = expectation(description: "Account linking initiates")
        KevinAccountLinkingSession.shared.initiateAccountLinking(configuration: configuration)
        
        waitForExpectations(timeout: 0.1)
        
        let resultVC = try XCTUnwrap(controller)
        let resultAccountLinkingViewController = resultVC.topViewController as? KevinAccountLinkingViewController
        
        expectation = expectation(description: "Account linking cancelled")
        resultAccountLinkingViewController?.onClose?()
        
        waitForExpectations(timeout: 0.1)

        // 3. Assert
        let resultError = try XCTUnwrap(error)
        let resultCancelationError = resultError as? KevinCancelationError

        XCTAssertNotNil(resultCancelationError)
    }
    
    // MARK: - Linking completion
    
    func testLinkingCompletion() throws {
        // 1. Assign
        let bankId = "INDUSTRA_LT"
        
        let configuration = try KevinAccountLinkingSessionConfiguration.Builder(state: authStateMock)
            .build()

        // 2. Act
        expectation = expectation(description: "Account linking initiates")
        KevinAccountLinkingSession.shared.initiateAccountLinking(configuration: configuration)
        
        waitForExpectations(timeout: 0.1)

        expectation = expectation(description: "Account linking completed")
        KevinAccountLinkingSession.shared.notifyAccountLinkingCompletion(
            authorizationCode: authStateMock,
            bankId: bankId,
            country: nil,
            linkingType: .bank
        )
        
        waitForExpectations(timeout: 0.1)
        
        // 3. Assert
        let resultAuthorizationCode = try XCTUnwrap(authorizationCode)
        let resultBank = try XCTUnwrap(bank)

        XCTAssertEqual(resultAuthorizationCode, authStateMock)
        XCTAssertEqual(resultBank.id, bankId)
    }
    
    func testLinkingCompletionBankUnavailableError() throws {
        // 1. Assign
        let bankId = "UNAVAILABLE_BANK"
        
        let configuration = try KevinAccountLinkingSessionConfiguration.Builder(state: authStateMock)
            .build()

        // 2. Act
        expectation = expectation(description: "Account linking initiates")
        KevinAccountLinkingSession.shared.initiateAccountLinking(configuration: configuration)
        
        waitForExpectations(timeout: 0.1)

        expectation = expectation(description: "Account linking completed")
        KevinAccountLinkingSession.shared.notifyAccountLinkingCompletion(
            authorizationCode: authStateMock,
            bankId: bankId,
            country: nil,
            linkingType: .bank
        )
        
        waitForExpectations(timeout: 0.1)
        
        // 3. Assert
        let resultError = try XCTUnwrap(error) as? KevinError
        XCTAssertEqual(resultError, KevinErrors.preselectedBankNotSupported)
    }
    
    func testLinkingCompletionIncorrectBankCountryError() throws {
        // 1. Assign
        let bankId = "INDUSTRA_LT"
        let country = KevinCountry.austria
        
        let configuration = try KevinAccountLinkingSessionConfiguration.Builder(state: authStateMock)
            .build()
        
        MockURLProtocol.add(handler: MockRequestHandler(
            url: URL.banks(with: authStateMock).absoluteString + "?countryCode=\(country.rawValue)",
            jsonResponse: "" // NOTE: It doesn't matter if response is empty or not. It just shouldn't contain "INDUSTRA_LT" bank
        ))
        
        // 2. Act
        expectation = expectation(description: "Account linking initiates")
        KevinAccountLinkingSession.shared.initiateAccountLinking(configuration: configuration)
        
        waitForExpectations(timeout: 0.1)

        expectation = expectation(description: "Account linking completed")
        KevinAccountLinkingSession.shared.notifyAccountLinkingCompletion(
            authorizationCode: authStateMock,
            bankId: bankId,
            country: country,
            linkingType: .bank
        )
        
        waitForExpectations(timeout: 0.1)
        
        // 3. Assert
        let resultError = try XCTUnwrap(error) as? KevinError
        XCTAssertEqual(resultError, KevinErrors.preselectedBankNotSupported)
    }
}

extension LinkingSessionTests: KevinAccountLinkingSessionDelegate {

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
