//
//  AccountLinkingView.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 10/06/2022.
//

import SwiftUI

public struct AccountLinkingView: View {
    
    @StateObject var viewModel = AccountLinkingViewModel()
    
    public var body: some View {
        NavigationView {
            ZStack {
                Color("PrimaryBackgroundColor").ignoresSafeArea()
                    .zIndex(-1)

                if viewModel.viewState.isLoading {
                    ProgressView()
                } else if let linkedBanks = viewModel.viewState.linkedBanks, linkedBanks.isEmpty == false {
                    AccountsView(
                        linkedBanks: linkedBanks.toArray(),
                        linkBank: viewModel.invokeAccountLinkingSession,
                        deleteBank: viewModel.deleteLinkedBank
                    )
                    .navigationBarTitle("kevin_window_link_account_title".localized(), displayMode: .large)
                } else {
                    NoAccountsView(onLinkAccountAction: {
                        viewModel.invokeAccountLinkingSession()
                    })
                }
            }
        }
        .animation(.easeInOut(duration: 0.15))
        .sheet(isPresented: $viewModel.viewState.openKevin, content: {
            if let controller = viewModel.kevinController {
                KevinViewControllerRepresentable(controller: controller)
                    .presentation(canDismissSheet: false)
            }
        })
        .alert(isPresented: $viewModel.viewState.showMessage, content: {
            Alert(
                title: Text(viewModel.viewState.messageTitle!),
                message: Text(viewModel.viewState.messageDescription!),
                dismissButton: .default(Text("kevin_dialog_payment_success_button".localized()))
            )
        })
    }
}
