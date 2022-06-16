//
//  InitiateCardPaymentUseCase.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 16/06/2022.
//

import Combine
import Kevin

public class InitiateCardPaymentUseCase: BasePaymentInitiationUseCase, InitiatePaymentProtocol {
    
    public static let shared = InitiateCardPaymentUseCase()

    public func initiate(
        amount: String,
        email: String,
        iban: String,
        creditorName: String
    ) -> AnyPublisher<KevinInitiationState, Error> {
        resetSubject()
        invokeCardPaymentInitiationSession(amount: amount, email: email, iban: iban, creditorName: creditorName)
        return subject.eraseToAnyPublisher()
    }
    
    private func invokeCardPaymentInitiationSession(
        amount: String,
        email: String,
        iban: String,
        creditorName: String
    ) {
        apiClient.initializeCardPayment(
            amount: amount,
            email: email,
            iban: iban,
            creditorName: creditorName
        ).done { payment in
            do {
                KevinPaymentSession.shared.delegate = self
                try KevinPaymentSession.shared.initiatePayment(
                    configuration: KevinPaymentSessionConfiguration.Builder(
                        paymentId: payment.id
                    )
                    .setPaymentType(.card)
                    .setPreselectedCountry(.lithuania)
                    .build()
                )
            } catch {
                self.subject.send(completion: .failure(error))
            }
        }.catch { error in
            self.subject.send(completion: .failure(error))
        }
    }
}
