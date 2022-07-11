//
//  InitiateBankPaymentUseCase.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 16/06/2022.
//

import Combine
import Kevin

public class InitiateBankPaymentUseCase: BasePaymentInitiationUseCase, InitiatePaymentProtocol {
    
    public static let shared = InitiateBankPaymentUseCase()

    public func initiate(
        amount: Double,
        email: String,
        iban: String,
        creditorName: String
    ) -> AnyPublisher<KevinInitiationState, Error> {
        resetSubject()
        invokeBankPaymentInitiationSession(amount: amount, email: email, iban: iban, creditorName: creditorName)
        return subject.eraseToAnyPublisher()
    }
    
    private func invokeBankPaymentInitiationSession(
        amount: Double,
        email: String,
        iban: String,
        creditorName: String
    ) {
        apiClient.initializeBankPayment(
            amount: String(format: "%.2f", amount),
            email: email,
            iban: iban,
            creditorName: creditorName
        ).done { [weak self] payment in
            do {
                KevinPaymentSession.shared.delegate = self
                try KevinPaymentSession.shared.initiatePayment(
                    configuration: KevinPaymentSessionConfiguration.Builder(
                        paymentId: payment.id
                    )
                    .setPaymentType(.bank)
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
}
