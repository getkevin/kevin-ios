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
        
    func paymentTypeSelected(type newType: PaymentType) {
        viewState.selectedPaymentType = newType
    }
    
    func presentCountrySelector() {
        viewState.isCountrySelectorPresented = true
    }
    
    func onCounrtyCodeSelected(_ selectedCountryCode: String) {
        viewState.selectedCountryCode = selectedCountryCode
        getCharityList(forCountryCode: selectedCountryCode)
        viewState.isCountrySelectorPresented = false
    }
    
    func openLink(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    func toggleAgreement() {
        viewState.isAgreementChecked = !viewState.isAgreementChecked
        updateDonateButtonState()
    }
    
    func updateDonateButtonState() {
        viewState.isDonateButtonDisabled =
            !(viewState.isAgreementChecked &&
            !viewState.email.isEmpty &&
            viewState.email.isValidEmail() &&
            viewState.amountString != "0.00" &&
            viewState.selectedCharity != nil)
    }
    
    func onDonateButtonTapped() {        
        if viewState.selectedPaymentType == PaymentType.bank {
            invokeBankPaymentInitiationSession()
        } else {
            invokeCardPaymentInitiationSession()
        }
    }

    func getCountryList() {
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
    
    func getCharityList(forCountryCode countryCode: String) {
        viewState.isCharityLoading = true
        apiClient.getCharityList(forCountryCode: countryCode).done { apiCharities in
            self.viewState.charities = apiCharities.list
            self.viewState.selectedCharity = apiCharities.list.first
            self.viewState.isCharityLoading = false
        }.catch { error in
            self.parseError(error)
        }
    }
    
    func invokeBankPaymentInitiationSession() {
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
    
    func invokeCardPaymentInitiationSession() {
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
        
    //MARK: KevinPaymentSessionDelegate
    
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
        viewState.amountString = "0.00"
        viewState.isAgreementChecked = false
        viewState.showMessage = true
        viewState.messageTitle = "success_alert_title".localized()
        viewState.messageDescription = "success_alert_description".localized()
    }
}
