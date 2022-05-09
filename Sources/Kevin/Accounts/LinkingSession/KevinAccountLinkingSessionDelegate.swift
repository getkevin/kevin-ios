//
//  KevinAccountLinkingSessionDelegate.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import UIKit
import Foundation

public protocol KevinAccountLinkingSessionDelegate: AnyObject {
    func onKevinAccountLinkingStarted(controller: UINavigationController)
    func onKevinAccountLinkingCanceled(error: Error?)
    func onKevinAccountLinkingSucceeded(authorizationCode: String, bank: ApiBank)
//    NOTE: Disabled (for now) card linking functionality
//    func onKevinAccountLinkingSucceeded(authorizationCode: String, bank: ApiBank?, linkingType: KevinAccountLinkingType)
}
