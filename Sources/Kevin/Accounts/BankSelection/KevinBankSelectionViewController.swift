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
    
    private var uiStateHandler: KevinUIStateHandler!

    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "window_bank_selection_title".localized(for: Kevin.shared.locale.identifier)
        getView().delegate = self
        getViewModel().delegate = self
        offerIntent(.initialize(configuration: configuration))
        uiStateHandler = KevinUIStateHandler()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        uiStateHandler.setNavigationController(navigationController: navigationController)
        uiStateHandler.forceStopCancellation = false
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if uiStateHandler.isCancellationInvoked {
            self.onExit?()
        }
    }
    
    override func onCloseTapped() {
        switch configuration.confirmInteractiveDismiss {
        case .always: presentCloseAlert()
        case .never:  dismissView()
        }
    }
    
    private func presentCloseAlert() {
        let alert = UIAlertController(
            title: "dialog_exit_confirmation_title".localized(for: Kevin.shared.locale.identifier),
            message: configuration.exitSlug.localized(for: Kevin.shared.locale.identifier),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: "no".localized(for: Kevin.shared.locale.identifier),
            style: .cancel,
            handler: nil
        ))
        alert.addAction(UIAlertAction(
            title: "yes".localized(for: Kevin.shared.locale.identifier),
            style: .default,
            handler: { _ in
                self.dismissView()
            }
        ))
        present(alert, animated: true)
    }
    
    private func dismissView() {
        uiStateHandler.forceStopCancellation = true
        dismiss(animated: true, completion: nil)
        onExit?()
    }
}

extension KevinBankSelectionViewController: KevinBankSelectionViewModelDelegate {

    func didFailInitiatePayment(error: Error) {
        dismiss(animated: true)
        KevinPaymentSession.shared.notifyPaymentCancelation(error: error)
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
        uiStateHandler.forceStopCancellation = true
        onContinuation?(bankId, configuration.selectedCountry)
    }
}

extension KevinBankSelectionViewController: KevinCountrySelectionViewControllerDelegate {
    
    func onCountrySelected(countryCode: String) {
        configuration.selectedCountry = KevinCountry(rawValue: countryCode.lowercased())!
        offerIntent(.initialize(configuration: configuration))
    }
}
