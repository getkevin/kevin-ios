//
//  LinkingSessionTests.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 05/09/2023.
//  Copyright © 2023 kevin.. All rights reserved.
//

import XCTest

@testable import Kevin

@MainActor final class LinkingSessionTests: XCTestCase {
    
    let authStateMock = "authStateMock"
    let redirectURLMock = "https://redirectURLMock.test/authorization.html"
    
    var expectation: XCTestExpectation?
    var controller: UINavigationController?
    var error: Error?
    var authorizationCode: String?
    var bank: ApiBank?
    
    override func setUpWithError() throws {
        KevinApiClient.shared.urlSession = mockURLSession
        
        let configurationAccounts = KevinAccountsConfiguration.Builder(
            callbackUrl: URL(string: redirectURLMock)!
        ).build()
        KevinAccountsPlugin.shared.configure(configurationAccounts)

        MockURLProtocol.add(handler: MockRequestHandler(
            url: URL.banks(with: authStateMock).absoluteString,
            jsonResponse: banksResponse
        ))

        print("setUpWithError Linking Session Tests")
    }
    
    override func tearDownWithError() throws {
        MockURLProtocol.clearHandlers()
        print("tearDownWithError Linking Session Tests")
    }

    // MARK: - Initiation
    
    func testAccountLinkingInitiationWithBankSelectionView() throws {
        // 1. Assign
        KevinAccountLinkingSession.shared.delegate = self
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
        KevinAccountLinkingSession.shared.delegate = self
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
        KevinAccountLinkingSession.shared.delegate = self
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
        KevinAccountLinkingSession.shared.delegate = self
        let configuration = try KevinAccountLinkingSessionConfiguration.Builder(state: authStateMock)
            .setPreselectedBank("UNAVAILABLE_BANK")
            .build()

        // 2. Act
        expectation = expectation(description: "Account linking initiates")
        KevinAccountLinkingSession.shared.initiateAccountLinking(configuration: configuration)

        waitForExpectations(timeout: 0.1)

        // 3. Assert
        let resultError = try XCTUnwrap(error)
        XCTAssertEqual(resultError.localizedDescription, "Provided preselected bank is not supported")
    }
    
    func testAccountLinkingInitiationWithErrorBankFilterIncorrect() throws {
        // 1. Assign
        KevinAccountLinkingSession.shared.delegate = self
        let configuration = try KevinAccountLinkingSessionConfiguration.Builder(state: authStateMock)
            .setBankFilter(["UNAVAILABLE_BANK"])
            .build()

        // 2. Act
        expectation = expectation(description: "Account linking initiates")
        KevinAccountLinkingSession.shared.initiateAccountLinking(configuration: configuration)

        waitForExpectations(timeout: 0.1)

        // 3. Assert
        let resultError = try XCTUnwrap(error)
        XCTAssertEqual(resultError.localizedDescription, "Provided bank filter does not contain supported banks")
    }
    
    func testAccountLinkingInitiationWithNetworkError() throws {
        // 1. Assign
        KevinAccountLinkingSession.shared.delegate = self
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
        KevinAccountLinkingSession.shared.delegate = self
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
        KevinAccountLinkingSession.shared.delegate = self
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
