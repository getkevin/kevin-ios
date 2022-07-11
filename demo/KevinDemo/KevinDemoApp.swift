//
//  KevinDemoApp.swift
//  KevinDemo
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import SwiftUI
import Kevin

@main
struct KevinDemoApp: App {
    
    init() {
        Kevin.shared.theme = DemoKevinTheme()
        Kevin.shared.locale = Locale(identifier: "en")
        KevinAccountsPlugin.shared.configure(
            KevinAccountsConfiguration.Builder(
                callbackUrl: URL(string: "https://redirect.kevin.eu/authorization.html")!
            ).build()
        )
        KevinInAppPaymentsPlugin.shared.configure(
            KevinInAppPaymentsConfiguration.Builder(
                callbackUrl: URL(string: "https://redirect.kevin.eu/payment.html")!
            ).build()
        )
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
