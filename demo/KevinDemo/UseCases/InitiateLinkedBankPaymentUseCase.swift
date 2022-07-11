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
        amount: Double,
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
        amount: Double,
        email: String,
        iban: String,
        creditorName: String,
        bankId: String
    ) {
        guard let credentials = BankCredentialsPreferences.load(forBankId: bankId),
        let accessToken = credentials.accessToken else {
            subject.send(completion: .failure(KevinBankError.bankCredential))
            return
        }
        
        apiClient.initializeLinkedBankPayment(
            amount: String(format: "%.2f", amount),
            email: email,
            iban: iban,
            creditorName: creditorName,
            accessToken: accessToken
        ).done { [weak self] payment in
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
                self?.subject.send(completion: .failure(error))
            }
        }.catch { [weak self] error in
            self?.handleError(
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
        amount: Double,
        email: String,
        iban: String,
        creditorName: String,
        bankId: String
    ) {
        switch error {
        case let apiError as ApiError where apiError.statusCode == 401:
            refreshToken(
                amount: amount,
                email: email,
                iban: iban,
                creditorName: creditorName,
                bankId: bankId
            )
        default:
            subject.send(completion: .failure(error))
        }
    }
    
    private func refreshToken(
        amount: Double,
        email: String,
        iban: String,
        creditorName: String,
        bankId: String
    ) {
        guard let credentials = BankCredentialsPreferences.load(forBankId: bankId),
              let refreshToken = credentials.refreshToken else {
            subject.send(completion: .failure(KevinBankError.bankCredential))
            return
        }
        apiClient.refreshAccessToken(
            refreshToken: refreshToken
        ).done { [weak self] credentials in
            let bankCredentials = BankCredentials(
                bankId: bankId,
                accessToken: credentials.accessToken,
                refreshToken: credentials.refreshToken
            )

            BankCredentialsPreferences.save(bankCredentials)
            
            self?.initiatePayment(
                amount: amount,
                email: email,
                iban: iban,
                creditorName: creditorName,
                bankId: bankId
            )
        }.catch { [weak self] error in
            self?.subject.send(completion: .failure(error))
        }
    }
}
