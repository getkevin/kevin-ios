//
//  ViewController.swift
//  Sample
//
//  Created by Kacper Dziubek on 19/05/2023.
//

import UIKit

class MainViewController: UIViewController {

    lazy var accountLinkingButton: UIButton = {
        let button = UIButton(
            type: .system,
            primaryAction: UIAction(
                title: "Account linking",
                handler: { [weak self] _ in
                    self?.openAccountLinking()
                }
            )
        )
        return button
    }()

    lazy var bankPaymentButton: UIButton = {
        let button = UIButton(
            type: .system,
            primaryAction: UIAction(
                title: "Bank payment",
                handler: { [weak self] _ in
                    self?.openBankPayment()
                }
            )
        )
        return button
    }()

    lazy var cardPaymentButton: UIButton = {
        let button = UIButton(
            type: .system,
            primaryAction: UIAction(
                title: "Card payment",
                handler: { [weak self] _ in
                    self?.openCardPayment()
                }
            )
        )
        return button
    }()

    lazy var uiCustomisationButton: UIButton = {
        let button = UIButton(
            type: .system,
            primaryAction: UIAction(
                title: "UI Customisation",
                handler: { [weak self] _ in
                    self?.openUICustomisation()
                }
            )
        )
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let stackView = UIStackView(arrangedSubviews: [
            accountLinkingButton,
            bankPaymentButton,
            cardPaymentButton,
            uiCustomisationButton
        ])
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)
        view.addConstraints([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    @objc func openAccountLinking() {
        navigationController?.pushViewController(AccountLinkingViewController(), animated: true)
    }

    @objc func openCardPayment() {
        navigationController?.pushViewController(CardPaymentViewController(), animated: true)
    }

    @objc func openBankPayment() {
        navigationController?.pushViewController(BankPaymentViewController(), animated: true)
    }

    @objc func openUICustomisation() {
        navigationController?.pushViewController(UICustomisedAccountLinkingController(), animated: true)
    }
}
