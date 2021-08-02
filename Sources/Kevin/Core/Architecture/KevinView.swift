//
//  KevinView.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation
import UIKit

internal class KevinView<S : IKevinState> : UIView {
    
    required public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open func render(state: S) { }
    
    open func viewDidLoad() { }
    
    open func viewDidAppear() { }
    
    open func viewWillAppear() { }
    
    open func viewWillDisappear() { }
    
    open func handleKeyboardChanges(keyboardHeight: CGFloat, duration: TimeInterval) { }
}
