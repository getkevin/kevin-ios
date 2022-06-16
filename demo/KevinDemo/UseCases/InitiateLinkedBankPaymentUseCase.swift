//
//  InitiateLinkedBankPaymentUseCase.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 16/06/2022.
//

import Combine
import Kevin

public class InitiateLinkedBankPaymentUseCase: BasePaymentInitiationUseCase, InitiateLinkedPaymentProtocol {
    
    public static let shared = InitiateLinkedBankPaymentUseCase()

    public func initiate(
        amount: String,
        email: String,
        iban: String,
        creditorName: String,
        bankId: String
    ) -> AnyPublisher<KevinInitiationState, Error> {
        resetSubject()
        initiatePayment(amount: amount, email: email, iban: iban, creditorName: creditorName, bankId: bankId)
        return subject.eraseToAnyPublisher()
    }
    
    private func initiatePayment(
        amount: String,
        email: String,
        iban: String,
        creditorName: String,
        bankId: String
    ) {
        guard let credentials = BankCredentialsPreferences.load(forBankId: bankId),
        let accessToken = credentials.accessToken else {
            subject.send(completion: .failure(KevinBankCredentialError()))
            return
        }
        
        apiClient.initializeLinkedBankPayment(
            amount: amount,
            email: email,
            iban: iban,
            creditorName: creditorName,
            accessToken: accessToken
        ).done { payment in
            do {
                KevinPaymentSession.shared.delegate = self
                try KevinPaymentSession.shared.initiatePayment(
                    configuration: KevinPaymentSessionConfiguration.Builder(
                        paymentId: payment.id
                    )
                    .setSkipAuthentication(true)
                    .build()
                )
            } catch {
                self.subject.send(completion: .failure(error))
            }
        }.catch { error in
            self.handleError(
                error,
                amount: amount,
                email: email,
                iban: iban,
                creditorName: creditorName,
                bankId: bankId
            )
        }
    }
    
    private func handleError(
        _ error: Error,
        amount: String,
        email: String,
        iban: String,
        creditorName: String,
        bankId: String
    ) {
        switch error {
        case let apiError as ApiError:
            if apiError.statusCode == 401 {
                refreshToken(
                    amount: amount,
                    email: email,
                    iban: iban,
                    creditorName: creditorName,
                    bankId: bankId
                )
            } else {
                subject.send(completion: .failure(error))
            }
        default:
            subject.send(completion: .failure(error))
        }
    }
    
    private func refreshToken(
        amount: String,
        email: String,
        iban: String,
        creditorName: String,
        bankId: String
    ) {
        guard let credentials = BankCredentialsPreferences.load(forBankId: bankId),
              let refreshToken = credentials.refreshToken else {
            subject.send(completion: .failure(KevinBankCredentialError()))
            return
        }
        apiClient.refreshAccessToken(
            refreshToken: refreshToken
        ).done { credentials in
            let bankCredentials = BankCredentials(
                bankId: bankId,
                accessToken: credentials.accessToken,
                refreshToken: credentials.refreshToken
            )

            BankCredentialsPreferences.save(bankCredentials)
            
            self.initiatePayment(
                amount: amount,
                email: email,
                iban: iban,
                creditorName: creditorName,
                bankId: bankId
            )
        }.catch { error in
            self.subject.send(completion: .failure(error))
        }
    }
}
