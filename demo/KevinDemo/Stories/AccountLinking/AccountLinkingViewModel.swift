//
//  AccountLinkingViewModel.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 10/06/2022.
//

import Foundation
import Kevin
import Combine
import SwiftUI
import RealmSwift

public class AccountLinkingViewModel: ObservableObject {
    
    @Published var viewState = AccountLinkingViewState()
    private var cancellables = Set<AnyCancellable>()
    var kevinController: UIViewController? = nil

    public init() {
        viewState.linkedBanks = LinkedBankRepository.findAll()
        
        // Observe Results Notifications
        viewState.notificationToken = viewState.linkedBanks?.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                break
            case .update(let linkedBanks, _, _, _):
                self?.viewState.linkedBanks = linkedBanks
                self?.viewState.isLoading = false
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    deinit {
        viewState.notificationToken?.invalidate()
    }
    
    func invokeAccountLinkingSession() {
        guard !viewState.isLoading else {
            return
        }

        viewState.isLoading = true

        LinkAccountUseCase.shared.initiate()
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error) :
                    self?.handleError(error)
                default : break
                }
            } receiveValue: { [weak self] state in
                switch state {
                case .started(let controller) :
                    self?.onKevinAccountLinkingStarted(controller)
                case .finishedWithSuccess :
                    self?.viewState.isLoading = false
                }
            }.store(in: &cancellables)
    }
    
    func deleteLinkedBank(_ linkedBank: LinkedBank) {
        LinkedBankRepository.delete(linkedBank)
    }

    private func onKevinAccountLinkingStarted(_ controller: UIViewController) {
        kevinController = controller
        viewState.openKevin = true
    }

    // MARK: Error handling
    
    private func handleError(_ error: Error) {
        if let error = error as? KevinError {
            showErrorMessage(error.description)
        } else {
            showErrorMessage(error.localizedDescription)
        }
    }

    private func showErrorMessage(_ errorMessage: String?) {
        viewState.isLoading = false

        viewState.showMessage = true
        viewState.messageTitle = "kevin_error_alert_title".localized()
        viewState.messageDescription = errorMessage ?? "kevin_error_alert_description".localized()
    }
}
