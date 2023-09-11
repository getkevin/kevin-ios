//
//  PaymentSessionTests.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 05/09/2023.
//  Copyright © 2023 kevin.. All rights reserved.
//

import XCTest

@testable import Kevin

final class PaymentSessionTests: XCTestCase {
    
    let paymentIdMock = "paymentIdMock"
    let redirectURLMock = "https://redirectURLMock.test/authorization.html"
    
    var expectation: XCTestExpectation?
    var controller: UINavigationController?
    var error: Error?
    var paymentId: String?
    var status: KevinPaymentStatus?
    
    override func setUp() {
        KevinApiClient.shared.urlSession = mockURLSession
        
        let configurationPayments = KevinInAppPaymentsConfiguration.Builder(
            callbackUrl: URL(string: redirectURLMock)!
        ).build()
        KevinInAppPaymentsPlugin.shared.configure(configurationPayments)

        MockURLProtocol.add(handler: MockRequestHandler(
            url: URL.banks(with: paymentIdMock).absoluteString,
            jsonResponse: banksResponse
        ))
    }
    
    override func tearDown() {
        MockURLProtocol.clearHandlers()
    }

    // MARK: - Initiation
    
    func testPaymentInitiationWithBankSelectionView() throws {
        // 1. Assign
        KevinPaymentSession.shared.delegate = self
        let configuration = try KevinPaymentSessionConfiguration.Builder(paymentId: paymentIdMock)
            .build()

        // 2. Act
        expectation = expectation(description: "Payment initiates")
        KevinPaymentSession.shared.initiatePayment(configuration: configuration)

        waitForExpectations(timeout: 0.1)

        // 3. Assert
        let resultVC = try XCTUnwrap(controller)
        let resultBankSelectionViewController = resultVC.topViewController as? KevinBankSelectionViewController

        XCTAssertNotNil(resultBankSelectionViewController)
        XCTAssertNil(resultBankSelectionViewController?.configuration.selectedBankId)
    }

    func testPaymentInitiationWithBankSelectionViewWithPreselectedBank() throws {
        // 1. Assign
        let preselectedBankId = "INDUSTRA_LT"
        KevinPaymentSession.shared.delegate = self
        let configuration = try KevinPaymentSessionConfiguration.Builder(paymentId: paymentIdMock)
            .setPreselectedBank(preselectedBankId)
            .build()

        // 2. Act
        expectation = expectation(description: "Payment initiates")
        KevinPaymentSession.shared.initiatePayment(configuration: configuration)

        waitForExpectations(timeout: 0.1)

        // 3. Assert
        let resultVC = try XCTUnwrap(controller)
        let resultBankSelectionViewController = resultVC.topViewController as? KevinBankSelectionViewController

        XCTAssertNotNil(resultBankSelectionViewController)
        XCTAssertEqual(resultBankSelectionViewController?.configuration.selectedBankId, preselectedBankId)
    }


    func testPaymentInitiationWithAccountLinkingConfirmationView() throws {
        // 1. Assign
        KevinPaymentSession.shared.delegate = self
        let configuration = try KevinPaymentSessionConfiguration.Builder(paymentId: paymentIdMock)
            .setPreselectedBank("INDUSTRA_LT")
            .setSkipBankSelection(true)
            .build()

        // 2. Act
        expectation = expectation(description: "Payment initiates")
        KevinPaymentSession.shared.initiatePayment(configuration: configuration)

        waitForExpectations(timeout: 0.1)

        // 3. Assert
        let resultVC = try XCTUnwrap(controller)
        XCTAssert(resultVC.topViewController is KevinPaymentConfirmationViewController)
    }

    func testPaymentInitiationWithErrorPreselectedBankIncorrect() throws {
        // 1. Assign
        KevinPaymentSession.shared.delegate = self
        let configuration = try KevinPaymentSessionConfiguration.Builder(paymentId: paymentIdMock)
            .setPreselectedBank("UNAVAILABLE_BANK")
            .build()

        // 2. Act
        expectation = expectation(description: "Payment initiates")
        KevinPaymentSession.shared.initiatePayment(configuration: configuration)

        waitForExpectations(timeout: 0.1)

        // 3. Assert
        let resultError = try XCTUnwrap(error) as? KevinError
        XCTAssertEqual(resultError, KevinErrors.preselectedBankNotSupported)
    }

    func testPaymentInitiationWithErrorBankFilterIncorrect() throws {
        // 1. Assign
        KevinPaymentSession.shared.delegate = self
        let configuration = try KevinPaymentSessionConfiguration.Builder(paymentId: paymentIdMock)
            .setBankFilter(["UNAVAILABLE_BANK"])
            .build()

        // 2. Act
        expectation = expectation(description: "Payment initiates")
        KevinPaymentSession.shared.initiatePayment(configuration: configuration)

        waitForExpectations(timeout: 0.1)

        // 3. Assert
        let resultError = try XCTUnwrap(error) as? KevinError
        XCTAssertEqual(resultError, KevinErrors.filterInvalid)
    }

    func testPaymentInitiationWithNetworkError() throws {
        // 1. Assign
        KevinPaymentSession.shared.delegate = self
        let configuration = try KevinPaymentSessionConfiguration.Builder(paymentId: paymentIdMock)
            .build()

        MockURLProtocol.clearHandlers()
        MockURLProtocol.add(handler: MockRequestHandler(
            url: URL.banks(with: paymentIdMock).absoluteString,
            statusCode: 404
        ))

        // 2. Act
        expectation = expectation(description: "Payment initiates")
        KevinPaymentSession.shared.initiatePayment(configuration: configuration)

        waitForExpectations(timeout: 0.1)

        // 3. Assert
        let resultError = try XCTUnwrap(error)
        let resultApiError = resultError as? KevinApiError

        XCTAssertNotNil(resultApiError)
    }

    // MARK: - Cancelation

    func testPaymentCancelationOnBankSelectionView() throws {
        // 1. Assign
        KevinPaymentSession.shared.delegate = self
        let configuration = try KevinPaymentSessionConfiguration.Builder(paymentId: paymentIdMock)
            .build()

        // 2. Act
        expectation = expectation(description: "Payment initiates")
        KevinPaymentSession.shared.initiatePayment(configuration: configuration)

        waitForExpectations(timeout: 0.1)

        let resultVC = try XCTUnwrap(controller)
        let resultBankSelectionViewController = resultVC.topViewController as? KevinBankSelectionViewController

        expectation = expectation(description: "Payment cancelled")
        resultBankSelectionViewController?.onExit?()

        waitForExpectations(timeout: 0.1)

        // 3. Assert
        let resultError = try XCTUnwrap(error)
        let resultCancelationError = resultError as? KevinCancelationError

        XCTAssertNotNil(resultCancelationError)
    }

    // MARK: - Linking completion

    func testPaymentCompletion() throws {
        // 1. Assign
        let status = KevinPaymentStatus.completed

        KevinPaymentSession.shared.delegate = self
        let configuration = try KevinPaymentSessionConfiguration.Builder(paymentId: paymentIdMock)
            .build()

        // 2. Act
        expectation = expectation(description: "Payment initiates")
        KevinPaymentSession.shared.initiatePayment(configuration: configuration)

        waitForExpectations(timeout: 0.1)

        expectation = expectation(description: "Payment completed")
        KevinPaymentSession.shared.notifyPaymentCompletion(
            paymentId: paymentIdMock,
            status: status
        )

        waitForExpectations(timeout: 0.1)

        // 3. Assert
        let resultPaymentId = try XCTUnwrap(paymentId)
        let resultStatus = try XCTUnwrap(status)

        XCTAssertEqual(resultPaymentId, paymentIdMock)
        XCTAssertEqual(resultStatus, status)
    }

    func testPaymentPending() throws {
        // 1. Assign
        let status = KevinPaymentStatus.pending

        KevinPaymentSession.shared.delegate = self
        let configuration = try KevinPaymentSessionConfiguration.Builder(paymentId: paymentIdMock)
            .build()

        // 2. Act
        expectation = expectation(description: "Payment initiates")
        KevinPaymentSession.shared.initiatePayment(configuration: configuration)

        waitForExpectations(timeout: 0.1)

        expectation = expectation(description: "Payment completed")
        KevinPaymentSession.shared.notifyPaymentCompletion(
            paymentId: paymentIdMock,
            status: status
        )

        waitForExpectations(timeout: 0.1)

        // 3. Assert
        let resultPaymentId = try XCTUnwrap(paymentId)
        let resultStatus = try XCTUnwrap(status)

        XCTAssertEqual(resultPaymentId, paymentIdMock)
        XCTAssertEqual(resultStatus, status)
    }
    
    func testPaymentUnknown() throws {
        // 1. Assign
        let status = KevinPaymentStatus.unknown

        KevinPaymentSession.shared.delegate = self
        let configuration = try KevinPaymentSessionConfiguration.Builder(paymentId: paymentIdMock)
            .build()

        // 2. Act
        expectation = expectation(description: "Payment initiates")
        KevinPaymentSession.shared.initiatePayment(configuration: configuration)

        waitForExpectations(timeout: 0.1)

        expectation = expectation(description: "Payment completed")
        KevinPaymentSession.shared.notifyPaymentCompletion(
            paymentId: paymentIdMock,
            status: status
        )

        waitForExpectations(timeout: 0.1)

        // 3. Assert
        let resultPaymentId = try XCTUnwrap(paymentId)
        let resultStatus = try XCTUnwrap(status)

        XCTAssertEqual(resultPaymentId, paymentIdMock)
        XCTAssertEqual(resultStatus, status)
    }
}

extension PaymentSessionTests: KevinPaymentSessionDelegate {
    func onKevinPaymentInitiationStarted(controller: UINavigationController) {
        self.controller = controller
        expectation?.fulfill()
        expectation = nil
    }
    
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
