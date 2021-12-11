//
//  MainViewModel.swift
//  KevinDemo
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation
import UIKit
import Localize_Swift
import Kevin

class MainViewModel: ObservableObject, KevinAccountLinkingSessionDelegate, KevinPaymentSessionDelegate {
    
    @Published var viewState = MainViewState()
    
    var kevinController: UIViewController? = nil
    
    private let apiClient = DemoApiClientFactory.createDemoApiClient(headers: RequestHeaders())
    
    func invokeAccountLinkingSession() {
        viewState = MainViewState(isLoading: true)
        apiClient.getAuthState().done { state in
            do {
                KevinAccountLinkingSession.shared.delegate = self
                try KevinAccountLinkingSession.shared.initiateAccountLinking(
                    configuration: KevinAccountLinkingSessionConfiguration.Builder(
                        state: state.state
                    )
                    .setPreselectedCountry(.lithuania)
                    .setCountryFilter([.lithuania, .latvia, .estonia])
                    .setSkipBankSelection(false)
                    .build()
                )
            } catch {
                self.parseError(error)
            }
        }.catch { error in
            self.parseError(error)
        }
    }
    
    func invokeBankPaymentInitiationSession() {
        viewState = MainViewState(isLoading: true)
        apiClient.initializeBankPayment().done { state in
            do {
                KevinPaymentSession.shared.delegate = self
                try KevinPaymentSession.shared.initiatePayment(
                    configuration: KevinPaymentSessionConfiguration.Builder(
                        paymentId: state.id
                    )
                    .setPreselectedCountry(.lithuania)
                    .setSkipBankSelection(false)
                    .build()
                )
            } catch {
                self.parseError(error)
            }
        }.catch { error in
            self.parseError(error)
        }
    }
    
    func invokeCardPaymentInitiationSession() {
        viewState = MainViewState(isLoading: true)
        apiClient.initializeCardPayment().done { state in
            do {
                KevinPaymentSession.shared.delegate = self
                try KevinPaymentSession.shared.initiatePayment(
                    configuration: KevinPaymentSessionConfiguration.Builder(
                        paymentId: state.id
                    )
                    .setPaymentType(.card)
                    .build()
                )
            } catch {
                self.parseError(error)
            }
        }.catch { error in
            self.parseError(error)
        }
    }
    
    private func parseError(_ error: Error) {
        if let error = error as? KevinError {
            showErrorMessage(error.description)
        } else {
            showErrorMessage(error.localizedDescription)
        }
    }
    
    private func showErrorMessage(_ errorMessage: String?) {
        self.viewState = MainViewState(
            isLoading: false,
            showMessage: true,
            messageTitle: "error_alert_title".localized(),
            messageDescription: errorMessage ?? ""
        )
    }
    
    //MARK: KevinAccountLinkingSessionDelegate
    
    func onKevinAccountLinkingStarted(controller: UIViewController) {
        self.kevinController = controller
        self.viewState = MainViewState(openKevin: true)
    }
    
    func onKevinAccountLinkingCanceled(error: Error?) {
        if let error = error {
            parseError(error)
        } else {
            showErrorMessage(String(format: "account_linking_was_canceled".localized()))
        }
    }
    
    func onKevinAccountLinkingSucceeded(authorizationCode: String, bank: ApiBank) {
        self.viewState = MainViewState(
            showMessage: true,
            messageTitle: "success_alert_title".localized(),
            messageDescription: String(format: "success_alert_description".localized(), " authorizationCode - \(authorizationCode)")
        )
    }
    
    //MARK: KevinPaymentSessionDelegate
    
    func onKevinPaymentInitiationStarted(controller: UIViewController) {
        self.kevinController = controller
        self.viewState = MainViewState(openKevin: true)
    }
    
    func onKevinPaymentCanceled(error: Error?) {
        if let error = error {
            parseError(error)
        } else {
            showErrorMessage(String(format: "payment_was_canceled".localized()))
        }
    }
    
    func onKevinPaymentSucceeded(paymentId: String) {
        self.viewState = MainViewState(
            showMessage: true,
            messageTitle: "success_alert_title".localized(),
            messageDescription: String(format: "success_alert_description".localized(), paymentId)
        )
    }
}
