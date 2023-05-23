//
//  AccountLinkingViewController.swift
//  Sample
//
//  Created by Kacper Dziubek on 19/05/2023.
//

import UIKit
import Kevin

class AccountLinkingViewController: UIViewController {

    let demoApiService = DemoApiService()

    lazy var linkingButton: UIButton = {
        let button = UIButton(
            type: .system,
            primaryAction: UIAction(
                title: "Initiate account linking",
                handler: { [weak self] _ in
                    self?.initiateAccointLinking()
                }
            )
        )
        return button
    }()

    lazy var linkingStatusText: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Account linking"

        let stackView = UIStackView(arrangedSubviews: [
            linkingStatusText,
            linkingButton
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
     * Start account linking session and configure to your requirements.
     * More info: https://developer.kevin.eu/home/mobile-sdk/ios/account-linking
     */
    @objc func initiateAccointLinking() {
        Task {
            do {
                let request = AuthStateRequest(
                    scopes: ["accounts_basic"],
                    redirectUrl: try KevinAccountsPlugin.shared.getCallbackUrl().absoluteString
                )

                let state = try await demoApiService.fetchAuthState(request: request)

                let configuration = try KevinAccountLinkingSessionConfiguration.Builder(state: state.state)
                    .setPreselectedCountry(.lithuania)
                    .setCountryFilter([.lithuania, .latvia, .estonia])
                    .setSkipBankSelection(false)
                    .build()

                /**
                 * Set the delegate to obtain linking  session result.
                 */
                KevinAccountLinkingSession.shared.delegate = self
                KevinAccountLinkingSession.shared.initiateAccountLinking(configuration: configuration)
            } catch {
                print(error)
            }

        }
    }
}

extension AccountLinkingViewController: KevinAccountLinkingSessionDelegate {
    func onKevinAccountLinkingStarted(controller: UINavigationController) {
        linkingStatusText.text = "Linking started"
        present(controller, animated: true)
    }

    func onKevinAccountLinkingCanceled(error: Error?) {
        linkingStatusText.text = "Linking cancelled \(String(describing: error))"
    }

    func onKevinAccountLinkingSucceeded(authorizationCode: String, bank: ApiBank?, linkingType: KevinAccountLinkingType) {
        linkingStatusText.text = "\(String(describing: bank?.name)) linked correctly."
    }
}
