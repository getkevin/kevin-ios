//
//  ContentView.swift
//  KevinDemo
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Localize_Swift
import Kevin
import SwiftUI
import UIKit

struct MainView: View {

    @ObservedObject var viewModel: MainViewModel

    var body: some View {
        VStack(spacing: 20) {
            Image("Logo")
                .resizable()
                .frame(width: 100, height: 100)
            Spacer()
            
            Button {
                viewModel.invokeAccountLinkingSession()
            } label: {
                Text("link_account".localized())
            }.buttonStyle(MainButtonStyle())
            
            Button {
                viewModel.invokeBankPaymentInitiationSession()
            } label: {
                Text("make_bank_payment".localized())
            }.buttonStyle(MainButtonStyle())
            
            Button {
                viewModel.invokeCardPaymentInitiationSession()
            } label: {
                Text("make_card_payment".localized())
            }.buttonStyle(MainButtonStyle())
        
            
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
                    dismissButton: .default(Text("action_ok".localized()))
                )
            })
            
            ProgressView().padding(30).opacity(viewModel.viewState.isLoading ? 1 : 0)
            Spacer()
        }
        .padding(20)
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        MainView(viewModel: MainViewModel())
    }
}
