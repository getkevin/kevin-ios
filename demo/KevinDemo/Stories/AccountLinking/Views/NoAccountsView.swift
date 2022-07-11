//
//  NoAccountsView.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 10/06/2022.
//

import SwiftUI

struct NoAccountsView: View {
    
    private let onLinkAccountAction: () -> Void

    init(onLinkAccountAction: @escaping () -> Void) {
        self.onLinkAccountAction = onLinkAccountAction
    }
    
    var body: some View {
        VStack {
            Image("Banks")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.bottom, 16)
            
            Text("kevin_window_link_account_empty_state_title".localized())
                .style(.title)
                .multilineTextAlignment(.center)
                .padding(16)

            Text("kevin_window_link_account_empty_state_subtitle".localized())
                .style(.subtitle)
                .multilineTextAlignment(.center)
                .padding(.bottom, 32)
                .padding(.horizontal, 16)

            Button {
                onLinkAccountAction()
            } label: {
                Text("kevin_window_link_account_empty_state_link_button".localized())
            }.buttonStyle(MainButtonStyle())
        }
    }
}
