//
//  KevinBankSelectionViewController.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation
import UIKit

internal class KevinBankSelectionViewController :
    KevinViewController<KevinBankSelectionViewModel, KevinBankSelectionView, KevinBankSelectionState, KevinBankSelectionIntent> {
    
    public var configuration: KevinBankSelectionConfiguration!
    
    public var onContinuation: ((String) -> ())?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("window_bank_selection_title", bundle: Bundle.module, comment: "")
        getView().delegate = self
        self.offerIntent(
            KevinBankSelectionIntent.Initialize(configuration: configuration)
        )
    }
}

extension KevinBankSelectionViewController: KevinBankSelectionViewDelegate {
    
    func openCountrySelection() {
        let controller = KevinCountrySelectionViewController()
        controller.delegate = self
        controller.modalPresentationStyle = .overCurrentContext
        controller.configuration = KevinCountrySelectionConfiguration(
            selectedCountry: configuration.selectedCountry!.rawValue,
            countryFilter: configuration.countryFilter,
            authState: configuration.authState
        )
        self.present(controller, animated: false)
    }
    
    func invokeContinuation(bankId: String) {
        onContinuation?(bankId)
    }
}

extension KevinBankSelectionViewController: KevinCountrySelectionViewControllerDelegate {
    
    func onCountrySelected(countryCode: String) {
        configuration.selectedCountry = KevinCountry(rawValue: countryCode.lowercased())
        self.offerIntent(
            KevinBankSelectionIntent.Initialize(
                configuration: configuration
            )
        )
    }
}
