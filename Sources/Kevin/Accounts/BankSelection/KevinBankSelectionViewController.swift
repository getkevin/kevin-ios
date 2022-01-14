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
    
    private var flowHasBeenProcessed = false
    private var isCancellationInvoked = false
    private var previousNavigationBarBackgroundColor: UIColor?
    private var previousStatusBarBackgroundColor: UIColor?

    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "window_bank_selection_title".localized(for: Kevin.shared.locale.identifier)
        getView().delegate = self
        self.offerIntent(
            KevinBankSelectionIntent.Initialize(configuration: configuration)
        )
        previousNavigationBarBackgroundColor = navigationController?.navigationBar.backgroundColor
        previousStatusBarBackgroundColor = UIApplication.shared.statusBarUIView?.backgroundColor
        if !(navigationController is KevinNavigationViewController) {
            findRootViewController()?.findNestedNavigationController()?.navigationBar.backgroundColor = Kevin.shared.theme.navigationBarBackgroundColor
            if #available(iOS 12.0, *) {
                if UIScreen.main.traitCollection.userInterfaceStyle == .light {
                    UIApplication.shared.statusBarUIView?.backgroundColor = Kevin.shared.theme.navigationBarBackgroundColor
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        flowHasBeenProcessed = false
    }
        
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isCancellationInvoked = !(navigationController is KevinNavigationViewController) && !flowHasBeenProcessed
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isCancellationInvoked {
            self.onExit?()
        }
        findRootViewController()?.findNestedNavigationController()?.navigationBar.backgroundColor = previousNavigationBarBackgroundColor
        UIApplication.shared.statusBarUIView?.backgroundColor = previousStatusBarBackgroundColor
    }
    
    override func onCloseTapped() {
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
                self.flowHasBeenProcessed = true
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
        flowHasBeenProcessed = true
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
