//
//  AppDelegate.swift
//  Sample
//
//  Created by Kacper Dziubek on 19/05/2023.
//

import UIKit
import Kevin

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        setupKevinSDK()

        return true
    }

    private func setupKevinSDK() {
        /**
         When deep linking is enabled, native banks/services applications
         will be used during authorization process (if available).
         */
        Kevin.shared.isDeepLinkingEnabled = true

        /**
         Change to `true` to use kevin. Sandbox environment to avoid making a real money payment / account linking attempts.
         */
        Kevin.shared.isSandbox = false

        // Configure account linking plugin with callback url.
        let configurationAccounts = KevinAccountsConfiguration.Builder(
            callbackUrl: URL(string: "https://redirect.kevin.eu/authorization.html")!
        ).build()

        KevinAccountsPlugin.shared.configure(configurationAccounts)

        // Configure payments with callback url (if you are using SDK to initiate payments).
        let configurationPayments = KevinInAppPaymentsConfiguration.Builder(
            callbackUrl: URL(string: "https://redirect.kevin.eu/payment.html")!
        ).build()

        KevinInAppPaymentsPlugin.shared.configure(configurationPayments)
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) { }

}
