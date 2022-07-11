//
//  BasePaymentInitiationUseCase.swift
//  ShoppingModule
//
//  Created by Daniel Klinge on 16/06/2022.
//

import Foundation
import UIKit
import Combine
import Kevin

public class BasePaymentInitiationUseCase: BasePublishingUseCase<KevinInitiationState>, KevinPaymentSessionDelegate {
        
    public var cancellables = Set<AnyCancellable>()
    
    // MARK: KevinPaymentSessionDelegate

    public func onKevinPaymentInitiationStarted(controller: UINavigationController) {
        subject.send(KevinInitiationState.started(controller: controller))
    }
    
    public func onKevinPaymentCanceled(error: Error?) {
        subject.send(completion: .failure(error ?? KevinBankError.userInterruption))
    }
    
    public func onKevinPaymentSucceeded(paymentId: String, status: KevinPaymentStatus) {
        subject.send(.finishedWithSuccess(result: paymentId))
        subject.send(completion: .finished)
    }
}
