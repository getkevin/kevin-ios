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

class MainViewModel: ObservableObject, KevinPaymentSessionDelegate {
    
    @Published var viewState = MainViewState()
    
    var kevinController: UIViewController? = nil
    
    private let apiClient = DemoApiClientFactory.createDemoApiClient(headers: RequestHeaders())
    
    init() {
        getCountryList()
    }
        
    func selectPaymentType(type newType: PaymentType) {
        viewState.selectedPaymentType = newType
    }
    
    func openCountrySelection() {
        viewState.isCountrySelectorPresented = true
    }
    
    func selectCountry(_ selectedCountryCode: String) {
        viewState.selectedCountryCode = selectedCountryCode
        getCharityList(forCountryCode: selectedCountryCode)
        viewState.isCountrySelectorPresented = false
    }
    
    func toggleAgreement() {
        viewState.isAgreementChecked = !viewState.isAgreementChecked
        updateDonateButtonState()
    }
    
    func openAgreementLink(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    func updateDonateButtonState() {
        viewState.isDonateButtonDisabled =
            !(viewState.isAgreementChecked &&
            viewState.email.isValidEmail() &&
            Double(viewState.amountString) != nil &&
            viewState.selectedCharity != nil)
    }
    
    func makeDonation() {
        if viewState.selectedPaymentType == PaymentType.bank {
            invokeBankPaymentInitiationSession()
        } else {
            invokeCardPaymentInitiationSession()
        }
    }
    
    //  MARK: Network requests

    private func getCountryList() {
        viewState.isCountryLoading = true
        viewState.isCharityLoading = true
        apiClient.getCountryList().done { apiCountries in
            self.viewState.countryCodes = apiCountries.list
            self.viewState.selectedCountryCode = "LT"
            self.viewState.isCountryLoading = false
            self.getCharityList(forCountryCode: "LT")
        }.catch { error in
            self.parseError(error)
        }
    }
    
    private func getCharityList(forCountryCode countryCode: String) {
        var targetCountryCode = countryCode.uppercased()
        if targetCountryCode != "LT" {
            targetCountryCode = "EE"
        }
        viewState.isCharityLoading = true
        apiClient.getCharityList(forCountryCode: targetCountryCode).done { apiCharities in
            self.viewState.charities = apiCharities.list
            self.viewState.selectedCharity = apiCharities.list.first
            self.viewState.isCharityLoading = false
        }.catch { error in
            self.parseError(error)
        }
    }
    
    private func invokeBankPaymentInitiationSession() {
        viewState.isPaymentInProgress = true
        apiClient.initializeBankPayment(
            amount: viewState.amountString,
            email: viewState.email,
            iban: viewState.selectedCharity!.iban,
            creditorName: viewState.selectedCharity!.name
        ).done { state in
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
    
    private func invokeCardPaymentInitiationSession() {
        viewState.isPaymentInProgress = true
        apiClient.initializeCardPayment(
            amount: viewState.amountString,
            email: viewState.email,
            iban: viewState.selectedCharity!.iban,
            creditorName: viewState.selectedCharity!.name
        ).done { state in
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
        self.viewState.isCountryLoading = false
        self.viewState.isCharityLoading = false
        self.viewState.isPaymentInProgress = false

        self.viewState.showMessage = true
        self.viewState.messageTitle = "error_alert_title".localized()
        self.viewState.messageDescription = errorMessage ?? "error_alert_description".localized()
    }
        
    //  MARK: KevinPaymentSessionDelegate
    
    func onKevinPaymentInitiationStarted(controller: UINavigationController) {
        self.kevinController = controller
        self.viewState.openKevin = true
    }
    
    func onKevinPaymentCanceled(error: Error?) {
        if let error = error {
            parseError(error)
        } else {
            showErrorMessage(String(format: "payment_was_canceled".localized()))
        }
    }
    
    func onKevinPaymentSucceeded(paymentId: String) {
        if viewState.selectedCountryCode != "LT" {
            viewState.selectedCountryCode = "LT"
            getCharityList(forCountryCode: "LT")
        }
        viewState.email = ""
        viewState.amountString = ""
        viewState.isAgreementChecked = false
        viewState.showMessage = true
        viewState.messageTitle = "success_alert_title".localized()
        viewState.messageDescription = "success_alert_description".localized()
    }
}
