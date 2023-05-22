//
//  CardPaymentViewController.swift
//  Sample
//
//  Created by Kacper Dziubek on 19/05/2023.
//

import UIKit
import Kevin

class CardPaymentViewController: UIViewController {

    let demoApiService = DemoApiService()

    lazy var cardPaymentButton: UIButton = {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Card payment"

        let stackView = UIStackView(arrangedSubviews: [
            paymentStatusText,
            cardPaymentButton
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

    /**
     * Initiate unlinked card  payment process.
     * Can be configured with various options like preselected country, bank and others.
     *
     * For initialising card payment, you will need to obtain a paymentId.
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
                guard let paymentID = try await demoApiService.fetchCardPaymentID(country: country) else {
                    return
                }

                let configuration = try KevinPaymentSessionConfiguration.Builder(paymentId: paymentID)
                    .setPaymentType(.card)
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

extension CardPaymentViewController: KevinPaymentSessionDelegate {
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
