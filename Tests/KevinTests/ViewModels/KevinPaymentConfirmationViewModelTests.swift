//
//  KevinPaymentConfirmationViewModelTests.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 11/09/2023.
//  Copyright © 2023 kevin.. All rights reserved.
//

import XCTest

@testable import Kevin

final class KevinPaymentConfirmationViewModelTests: XCTestCase {
    
    let paymentIdMock = "paymentIdMock"
    let redirectURLMock = "https://redirectURLMock.test/authorization.html"

    var viewModel: KevinPaymentConfirmationViewModel!
    var state: KevinPaymentConfirmationState?

    var expectation: XCTestExpectation?
    var controller: UINavigationController?
    var error: Error?
    var paymentId: String?
    var status: KevinPaymentStatus?

    override func setUp() {
        super.setUp()
        
        // MARK: Set up networking mock
        KevinApiClient.shared.urlSession = mockURLSession
        MockURLProtocol.add(handler: MockRequestHandler(
            url: URL.banks(with: paymentIdMock).absoluteString,
            jsonResponse: banksResponse
        ))
        
        // MARK: Set up SDK
        let configurationPayments = KevinInAppPaymentsConfiguration.Builder(
            callbackUrl: URL(string: redirectURLMock)!
        ).build()
        KevinInAppPaymentsPlugin.shared.configure(configurationPayments)
        KevinPaymentSession.shared.delegate = self

        // MARK: Set up view model
        viewModel = KevinPaymentConfirmationViewModel()
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

        let configuration = KevinPaymentConfirmationConfiguration(
            paymentId: paymentIdMock,
            paymentType: .bank,
            selectedBank: selectedBankId,
            skipAuthentication: false,
            confirmInteractiveDismiss: .never
        )
        let intent = KevinPaymentConfirmationIntent.Initialize(configuration: configuration)

        let expectedBaseUrl = String(
            format: KevinApiPaths.bankPaymentUrl,
            configuration.paymentId,
            configuration.selectedBank!,
            Kevin.shared.locale.identifier.lowercased()
        )

        // 2. Act
        viewModel.offer(intent: intent)
        
        // 3. Assert
        XCTAssertEqual(state?.url.absoluteString.contains(expectedBaseUrl), true)
    }

    func testViewModelInitiationWithSkipAuthentication() {
        // 1. Assign
        let selectedBankId = "INDUSTRA_LT"

        let configuration = KevinPaymentConfirmationConfiguration(
            paymentId: paymentIdMock,
            paymentType: .bank,
            selectedBank: selectedBankId,
            skipAuthentication: true,
            confirmInteractiveDismiss: .never
        )
        let intent = KevinPaymentConfirmationIntent.Initialize(configuration: configuration)
        
        let expectedBaseUrl = String(
            format: KevinApiPaths.bankPaymentAuthenticatedUrl,
            configuration.paymentId,
            Kevin.shared.locale.identifier.lowercased()
        )

        // 2. Act
        viewModel.offer(intent: intent)
        
        // 3. Assert
        XCTAssertEqual(state?.url.absoluteString.contains(expectedBaseUrl), true)
    }

    func testViewModelPaymentCompletion() throws {
        // 1. Assign
        let url = URL(string: "\(redirectURLMock)/?paymentId=\(paymentIdMock)&status=ACSC&statusGroup=completed")
        let paymentCompletionIntent = KevinPaymentConfirmationIntent.HandlePaymentCompleted(
            url: url,
            error: nil
        )
        
        // 2. Act
        expectation = expectation(description: "Payment completed")
        viewModel.offer(intent: paymentCompletionIntent)
        waitForExpectations(timeout: 0.1)

        // 3. Assert
        let resultPaymentId = try XCTUnwrap(paymentId)
        let resultStatus = try XCTUnwrap(status)
        
        XCTAssertEqual(resultPaymentId, paymentIdMock)
        XCTAssertEqual(resultStatus, .completed)
    }

    func testViewModelPaymentCompletionWithMissingStatusGroup() throws {
        // 1. Assign
        let url = URL(string: "\(redirectURLMock)/?paymentId=\(paymentIdMock)&status=ACSC")
        let paymentCompletionIntent = KevinPaymentConfirmationIntent.HandlePaymentCompleted(
            url: url,
            error: nil
        )
        
        // 2. Act
        expectation = expectation(description: "Payment completed")
        viewModel.offer(intent: paymentCompletionIntent)
        waitForExpectations(timeout: 0.1)

        // 3. Assert
        let resultError = try XCTUnwrap(error) as? KevinError
        
        XCTAssertEqual(resultError, KevinErrors.unknownPaymentStatus)
    }
    
    func testViewModelPaymentCompletionWithUnknownStatusGroup() throws {
        // 1. Assign
        let url = URL(string: "\(redirectURLMock)/?paymentId=\(paymentIdMock)&status=ACSC&statusGroup=unknown")
        let paymentCompletionIntent = KevinPaymentConfirmationIntent.HandlePaymentCompleted(
            url: url,
            error: nil
        )
        
        // 2. Act
        expectation = expectation(description: "Payment completed")
        viewModel.offer(intent: paymentCompletionIntent)
        waitForExpectations(timeout: 0.1)

        // 3. Assert
        let resultError = try XCTUnwrap(error) as? KevinError
        
        XCTAssertEqual(resultError, KevinErrors.unknownPaymentStatus)
    }
    
    func testViewModelPaymentCompletionWithUnexpectedStatusGroup() throws {
        // 1. Assign
        let url = URL(string: "\(redirectURLMock)/?paymentId=\(paymentIdMock)&status=ACSC&statusGroup=unexpected")
        let paymentCompletionIntent = KevinPaymentConfirmationIntent.HandlePaymentCompleted(
            url: url,
            error: nil
        )
        
        // 2. Act
        expectation = expectation(description: "Payment completed")
        viewModel.offer(intent: paymentCompletionIntent)
        waitForExpectations(timeout: 0.1)

        // 3. Assert
        let resultError = try XCTUnwrap(error) as? KevinError
        
        XCTAssertEqual(resultError, KevinErrors.unknownPaymentStatus)
    }
    
    func testViewModelPaymentCompletionWithError() throws {
        // 1. Assign
        let error = KevinError(description: "Custom test error")
        let paymentCompletionIntent = KevinPaymentConfirmationIntent.HandlePaymentCompleted(
            url: nil,
            error: error
        )
        
        // 2. Act
        expectation = expectation(description: "Payment completed")
        viewModel.offer(intent: paymentCompletionIntent)
        waitForExpectations(timeout: 0.1)

        // 3. Assert
        let resultError = try XCTUnwrap(error)
        
        XCTAssertEqual(resultError, error)
    }
}

extension KevinPaymentConfirmationViewModelTests: KevinPaymentSessionDelegate {
    func onKevinPaymentInitiationStarted(controller: UINavigationController) { }
    
    func onKevinPaymentCanceled(error: Error?) {
        self.error = error
        expectation?.fulfill()
        expectation = nil
    }
    
    func onKevinPaymentSucceeded(paymentId: String, status: KevinPaymentStatus) {
        self.paymentId = paymentId
        self.status = status
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
