//
//  KevinViewModel.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

internal class KevinViewModel<S : IKevinState, I : IKevinIntent> {
    
    required init() { }
    
    var state: S? {
        didSet {
            guard let state = state else {
                return
            }

            onStateChanged(state)
        }
    }
    
    open var onStateChanged: (S)->() = { state in }
    
    open func offer(intent: I) { }
}
