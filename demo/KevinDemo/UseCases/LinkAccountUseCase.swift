//
//  LinkAccountUseCase.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 16/06/2022.
//

import UIKit
import Combine
import Kevin

public class LinkAccountUseCase: BasePublishingUseCase<KevinInitiationState>, KevinAccountLinkingSessionDelegate {

    public static let shared = LinkAccountUseCase()

    private var cancellables = Set<AnyCancellable>()

    func initiate() -> AnyPublisher<KevinInitiationState, Error> {
        resetSubject()
        invokeAccountLinkingSession()
        return subject.eraseToAnyPublisher()
    }
    
    private func invokeAccountLinkingSession() {
        apiClient.initializeAccountLinking().done { [weak self] state in
            do {
                KevinAccountLinkingSession.shared.delegate = self
                try KevinAccountLinkingSession.shared.initiateAccountLinking(
                    configuration: KevinAccountLinkingSessionConfiguration.Builder(
                        state: state.state
                    )
                    .setPreselectedCountry(.lithuania)
                    .setSkipBankSelection(false)
                    .build()
                )
            } catch {
                self?.subject.send(completion: .failure(error))
            }
        }.catch { [weak self] error in
            self?.subject.send(completion: .failure(error))
        }
    }

    private func getAccessToken(authorizationCode: String, bank: ApiBank) {
        apiClient.getAccessToken(
            authorizationCode: authorizationCode
        ).done { [weak self] credentials in
            let bankCredentials = BankCredentials(
                bankId: bank.id,
                accessToken: credentials.accessToken,
                refreshToken: credentials.refreshToken
            )

            BankCredentialsPreferences.save(bankCredentials)
            
            LinkedBankRepository.saveLinkedBank(bank)
            
            self?.subject.send(.finishedWithSuccess())
            self?.subject.send(completion: .finished)
        }.catch { [weak self] error in
            self?.subject.send(completion: .failure(error))
        }
    }

    // MARK: KevinPaymentSessionDelegate

    public func onKevinAccountLinkingStarted(controller: UINavigationController) {
        subject.send(.started(controller: controller))
    }

    public func onKevinAccountLinkingCanceled(error: Error?) {
        subject.send(completion: .failure(error ?? KevinBankError.userInterruption))
    }

    public func onKevinAccountLinkingSucceeded(authorizationCode: String, bank: ApiBank?, linkingType: KevinAccountLinkingType) {
        if linkingType == .bank, let bank = bank {
            getAccessToken(authorizationCode: authorizationCode, bank: bank)
        }
    }
}
