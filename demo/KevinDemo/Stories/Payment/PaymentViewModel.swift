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
import Combine
import RealmSwift

class PaymentViewModel: ObservableObject {

    @Published var viewState = PaymentViewState()
    @Published var isDonateButtonEnabled = true

    private let apiClient = DemoApiClientFactory.createDemoApiClient(headers: RequestHeaders())
    private var cancellables = Set<AnyCancellable>()
    var kevinController: UIViewController? = nil
        
    init() {
        getCountryList()
        
        viewState.linkedBanks = LinkedBankRepository.findAll()
        
        // Observe Results Notifications
        viewState.notificationToken = viewState.linkedBanks?.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                break
            case .update(let linkedBanks, _, _, _):
                self?.viewState.linkedBanks = linkedBanks
            case .error(let error):
                fatalError("\(error)")
            }
        }
        
        $viewState
            .map { state in
                state.isAgreementChecked &&
                state.email.isValidEmail() &&
                state.amount != 0.0 &&
                state.selectedCharity != nil
            }
            .assign(to: &$isDonateButtonEnabled)
    }
    
    deinit {
        viewState.notificationToken?.invalidate()
    }
    
    func openCountrySelection() {
        viewState.isCountrySelectorPresented = true
    }
    
    func selectCountry(_ selectedCountryCode: String) {
        viewState.selectedCountryCode = selectedCountryCode
        getCharityList(forCountryCode: selectedCountryCode)
        viewState.isCountrySelectorPresented = false
    }
    
    // MARK: Payment type selection
    
    func openPaymentTypeSelection() {
        viewState.isPaymentTypeSelectorPresented = true
    }

    func onPaymentTypeSelected(_ type: PaymentType) {
        viewState.isPaymentTypeSelectorPresented = false

        switch type {
        case .bank:
            invokePaymentInitiationSession(useCase: InitiateBankPaymentUseCase.shared)
        case .linkedBank:
            openLinkedBankSelection()
        case .card:
            invokePaymentInitiationSession(useCase: InitiateCardPaymentUseCase.shared)
        }
    }

    func openLinkedBankSelection() {
        if viewState.linkedBanks == nil || viewState.linkedBanks!.toArray().isEmpty {
            handleError(KevinBankError.noLinkedBank)
            return
        }
        
        viewState.isLinkedBankSelectorPresented = true
    }

    func onLinkedBankSelected(_ linkedBank: LinkedBank) {
        viewState.isLinkedBankSelectorPresented = false

        invokeLinkedBankPaymentInitiationSession(bankId: linkedBank.bankId)
    }

    private func getCountryList() {
        viewState.isCharityLoading = true
        apiClient.getCountryList().done { [weak self] apiCountries in
            self?.viewState.countryCodes = apiCountries.list
            self?.viewState.selectedCountryCode = "LT"
            self?.getCharityList(forCountryCode: "LT")
        }.catch { [weak self] error in
            self?.handleError(error)
        }
    }
    
    private func
    getCharityList(forCountryCode countryCode: String) {
        var targetCountryCode = countryCode.uppercased()
        if targetCountryCode != "LT" {
            targetCountryCode = "EE"
        }
        viewState.isCharityLoading = true
        apiClient.getCharityList(forCountryCode: targetCountryCode).done { [weak self] apiCharities in
            self?.viewState.charities = apiCharities.list
            self?.viewState.selectedCharity = apiCharities.list.first
            self?.viewState.isCharityLoading = false
        }.catch { [weak self] error in
            self?.handleError(error)
        }
    }
    
    private func invokePaymentInitiationSession(useCase: InitiatePaymentProtocol) {
        guard !viewState.isPaymentInProgress else {
            return
        }
        
        viewState.isPaymentInProgress = true
        
        useCase.initiate(
            amount: viewState.amount,
            email: viewState.email,
            iban: viewState.selectedCharity!.accounts.first!.iban,
            creditorName: viewState.selectedCharity!.name
        ).sink { [weak self] completion in
            switch completion {
            case .failure(let error) :
                self?.handleError(error)
            default : break
            }
        } receiveValue: { [weak self] state in
            switch state {
            case .started(let controller):
                self?.onKevinPaymentInitiationStarted(controller: controller)
            case .finishedWithSuccess(let result as String):
                self?.onKevinPaymentSucceeded(paymentId: result)
            default:
                break
            }
        }.store(in: &cancellables)
    }
    
    private func invokeLinkedBankPaymentInitiationSession(bankId: String) {
        guard !viewState.isPaymentInProgress else {
            return
        }

        viewState.isPaymentInProgress = true
        
        InitiateLinkedBankPaymentUseCase.shared.initiate(
            amount: viewState.amount,
            email: viewState.email,
            iban: viewState.selectedCharity!.accounts.first!.iban,
            creditorName: viewState.selectedCharity!.name,
            bankId: bankId
        ).sink { [weak self] completion in
            switch completion {
            case .failure(let error) :
                self?.handleError(error)
            default : break
            }
        } receiveValue: { [weak self] state in
            switch state {
            case .started(let controller) :
                self?.onKevinPaymentInitiationStarted(controller: controller)
            case .finishedWithSuccess(let result as String):
                self?.onKevinPaymentSucceeded(paymentId: result)
            default:
                break
            }
        }.store(in: &cancellables)
    }
    
    // Error handling
    
    private func handleError(_ error: Error) {
        if let error = error as? KevinError {
            showErrorMessage(error.description)
        } else {
            showErrorMessage(error.localizedDescription)
        }
    }
    
    private func showErrorMessage(_ errorMessage: String?) {
        viewState.isCharityLoading = false
        viewState.isPaymentInProgress = false

        viewState.showMessage = true
        viewState.messageTitle = "kevin_error_alert_title".localized()
        viewState.messageDescription = errorMessage ?? "kevin_error_alert_description".localized()
    }
        
    //  MARK: KevinPaymentSessionDelegate
    
    func onKevinPaymentInitiationStarted(controller: UIViewController) {
        kevinController = controller
        viewState.openKevin = true
    }
        
    func onKevinPaymentSucceeded(paymentId: String) {
        if viewState.selectedCountryCode != "LT" {
            viewState.selectedCountryCode = "LT"
            getCharityList(forCountryCode: "LT")
        }
        viewState.email = ""
        viewState.amount = 0.0
        viewState.isAgreementChecked = false
        viewState.showMessage = true
        viewState.messageTitle = "kevin_success_alert_title".localized()
        viewState.messageDescription = "kevin_success_alert_description".localized()
        viewState.isPaymentInProgress = false
    }
}
