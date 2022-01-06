//
//  KevinPaymentSessionDelegate.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import UIKit
import Foundation

public protocol KevinPaymentSessionDelegate: AnyObject {
    func onKevinPaymentInitiationStarted(controller: UINavigationController)
    func onKevinPaymentCanceled(error: Error?)
    func onKevinPaymentSucceeded(paymentId: String)
}
