//
//  KevinCountrySelectionViewController.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation
import UIKit

internal protocol KevinCountrySelectionViewControllerDelegate: AnyObject {
    func onCountrySelected(countryCode: String)
}

internal class KevinCountrySelectionViewController :
    KevinViewController<KevinCountrySelectionViewModel, KevinCountrySelectionView, KevinCountrySelectionState, KevinCountrySelectionIntent> {
    
    weak var delegate: KevinCountrySelectionViewControllerDelegate?
    
    var configuration: KevinCountrySelectionConfiguration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getView().delegate = self
        getView().modalDelegate = self
        self.offerIntent(
            KevinCountrySelectionIntent.Initialize(configuration: configuration)
        )
    }
}

extension KevinCountrySelectionViewController: KevinCountrySelectionViewDelegate, KevinModalViewDelegate {
    
    func onCountrySelected(countryCode: String) {
        delegate?.onCountrySelected(countryCode: countryCode)
    }
    
    func onDismiss() {
        self.dismiss(animated: false)
    }
}
