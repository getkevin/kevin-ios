//
//  KevinInitiationState.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 16/06/2022.
//

import Foundation
import UIKit

public enum KevinInitiationState {
    case started(controller: UIViewController)
    case finishedWithSuccess(result: Any? = nil)
}
