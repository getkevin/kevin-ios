//
//  InitiatePaymentProtocol.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 16/06/2022.
//

import Combine

public protocol InitiatePaymentProtocol {
    func initiate(amount: Double, email: String, iban: String, creditorName: String) -> AnyPublisher<KevinInitiationState, Error>
}
