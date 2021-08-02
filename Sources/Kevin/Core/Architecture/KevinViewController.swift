//
//  KevinViewController.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation
import UIKit

internal class KevinViewController<VM : KevinViewModel<S, I>, V : KevinView<S>, S : IKevinState, I : IKevinIntent> : UIViewController {
    
    private let viewModel = VM.init()
    
    open func offerIntent(_ intent: I) {
        viewModel.offer(intent: intent)
    }
    
    open override func loadView() {
        self.view = V.init(frame: UIScreen.main.bounds)
        viewModel.onStateChanged = { [weak self] state in
            self?.getView().render(state: state)
        }
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        getView().viewDidLoad()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getView().viewWillAppear()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getView().viewDidAppear()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        getView().viewWillDisappear()
    }
    
    open func getView() -> V {
        return self.view as! V
    }
}
