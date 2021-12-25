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
    
    public var onContinuation: ((String, KevinCountry?) -> ())?
    public var onExit: (() -> ())?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("window_bank_selection_title", bundle: Bundle.module, comment: "")
        getView().delegate = self
        self.offerIntent(
            KevinBankSelectionIntent.Initialize(configuration: configuration)
        )
    }
    
    override func onCloseTapped() {
        let alert = UIAlertController(
            title: NSLocalizedString("dialog_exit_confirmation_title", bundle: Bundle.module, comment: ""),
            message: NSLocalizedString(configuration.exitSlug, bundle: Bundle.module, comment: ""),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("no", bundle: Bundle.module, comment: ""),
            style: .cancel,
            handler: nil
        ))
        alert.addAction(UIAlertAction(
            title: NSLocalizedString("yes", bundle: Bundle.module, comment: ""),
            style: .default,
            handler: { _ in
                self.dismiss(animated: true, completion: nil)
                self.onExit?()
            }
        ))
        present(alert, animated: true)
    }
}

extension KevinBankSelectionViewController: KevinBankSelectionViewDelegate {
    
    func openCountrySelection() {
        let controller = KevinCountrySelectionViewController()
        controller.delegate = self
        controller.modalPresentationStyle = .overCurrentContext
        controller.configuration = KevinCountrySelectionConfiguration(
            selectedCountry: configuration.selectedCountry.rawValue,
            countryFilter: configuration.countryFilter,
            authState: configuration.authState
        )
        self.present(controller, animated: false)
    }
    
    func invokeContinuation(bankId: String) {
        onContinuation?(bankId, configuration.selectedCountry)
    }
}

extension KevinBankSelectionViewController: KevinCountrySelectionViewControllerDelegate {
    
    func onCountrySelected(countryCode: String) {
        configuration.selectedCountry = KevinCountry(rawValue: countryCode.lowercased())!
        self.offerIntent(
            KevinBankSelectionIntent.Initialize(
                configuration: configuration
            )
        )
    }
}
