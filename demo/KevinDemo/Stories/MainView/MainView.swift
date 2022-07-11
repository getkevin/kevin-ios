//
//  MainView.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 10/06/2022.
//

import SwiftUI

public struct MainView: View {
    
    @State var selectedTab: ApplicationTabs = .accountLinking
    
    public init() {
        let appearance: UITabBarAppearance = UITabBarAppearance()
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }

    public var body: some View {
        TabView(selection: $selectedTab) {
            AccountLinkingView()
                .tabItem {
                    selectedTab == .accountLinking ?
                    Image("TabAccountActive") :
                    Image("TabAccountInactive")
                    Text("kevin_window_link_account_title".localized())
                }
                .tag(ApplicationTabs.accountLinking)
            
            PaymentView()
                .tabItem {
                    selectedTab == .payment ?
                    Image("TabPaymentActive") :
                    Image("TabPaymentInactive")
                    Text("kevin_window_main_title_label".localized())
                }
                .tag(ApplicationTabs.payment)
        }
        .accentColor(Color("AccentColor"))
    }
}
