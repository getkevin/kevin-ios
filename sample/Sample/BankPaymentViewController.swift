//
//  BankPaymentViewController.swift
//  Sample
//
//  Created by Kacper Dziubek on 19/05/2023.
//

import UIKit
import Kevin

class BankPaymentViewController: UIViewController {

    let demoApiService = DemoApiService()

    lazy var bankPaymentButton: UIButton = {
        let button = UIButton(
            type: .system,
            primaryAction: UIAction(
                title: "Initiate payment",
                handler: { [weak self] _ in
                    self?.initiatePayment()
                }
            )
        )
        return button
    }()

    lazy var paymentStatusText: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()

    lazy var noticeText: UILabel = {
        let label = UILabel()
        label.text = "In this sample we use live production banks, so by completing the payment flow 0.01 EUR will be deducted from your account."
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Bank payment"

        let stackView = UIStackView(arrangedSubviews: [
            paymentStatusText,
            bankPaymentButton,
            noticeText
        ])
        stackView.spacing = 12
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)
        view.addConstraints([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
        ])
    }

    /**
     * Initiate unlinked bank account payment process.
     * Can be configured with various options like preselected country, bank and others.
     *
     * For initialising bank payment, you will need to obtain a paymentId.
     *
     * More info:
     *  - https://developer.kevin.eu/home/mobile-sdk/ios/payment-initiation
     *  - https://api-reference.kevin.eu/public/platform/v0.3#tag/Payment-Initiation-Service/operation/initiatePayment
     */
    @objc func initiatePayment() {
        // You can modify country to your own liking.
        let country = KevinCountry.lithuania

        Task {
            do {
                guard let paymentID = try await demoApiService.fetchBankPaymentID(country: country) else {
                    return
                }

                let configuration = try KevinPaymentSessionConfiguration.Builder(paymentId: paymentID)
                    .setPreselectedCountry(country)
                    .setSkipBankSelection(false)
                    .build()

                /**
                 * Set the delegate to obtain payment  session result.
                 */
                KevinPaymentSession.shared.delegate = self
                KevinPaymentSession.shared.initiatePayment(configuration: configuration)
            } catch {
                print(error)
            }

        }
    }
}

extension BankPaymentViewController: KevinPaymentSessionDelegate {
    func onKevinPaymentInitiationStarted(controller: UINavigationController) {
        present(controller, animated: true)
    }

    func onKevinPaymentCanceled(error: Error?) {
        paymentStatusText.text = "Payment error \(String(describing: error))"
    }

    func onKevinPaymentSucceeded(paymentId: String, status: KevinPaymentStatus) {
        paymentStatusText.text = "Payment status \(status)"
    }
}
