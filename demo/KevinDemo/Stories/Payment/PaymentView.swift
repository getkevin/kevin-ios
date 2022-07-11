//
//  PaymentView.swift
//  KevinDemo
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Localize_Swift
import Kevin
import SwiftUI
import UIKit
import HalfASheet

struct PaymentView: View {
    
    @StateObject var viewModel = PaymentViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("PrimaryBackgroundColor").ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading) {
                        Group {
                            Text("kevin_window_main_country_label".localized())
                                .style(.sectionHeader)
                                .padding(.bottom, 12)
                            
                            Button(action: {
                                viewModel.openCountrySelection()
                            }) {
                                KevinCountrySelectionCell(
                                    title: "kevin_window_main_country_label".localized(),
                                    countryCode: viewModel.viewState.selectedCountryCode
                                )
                            }
                        }
                        
                        Group {
                            Text("kevin_window_main_charity_label".localized())
                                .style(.sectionHeader)
                                .padding(.top, 28)
                                .padding(.bottom, 12)
                            
                            HStack(spacing: 0.0) {
                                if viewModel.viewState.isCharityLoading {
                                    Spacer()
                                    
                                    ProgressView()
                                    
                                    Spacer()
                                } else {
                                    Spacer(minLength: 0.0)
                                    
                                    ForEach(viewModel.viewState.charities, id: \.id) { charity in
                                        KevinCharityView(
                                            logoUrlString: charity.logo,
                                            isSelected: viewModel.viewState.selectedCharity?.id == charity.id,
                                            onTap: {
                                                viewModel.viewState.selectedCharity = charity
                                            }
                                        )
                                        .padding(.trailing, viewModel.viewState.charities.last?.id == charity.id ? 0.0 : 16.0)
                                    }
                                    
                                    Spacer(minLength: 0.0)
                                }
                            }
                            .frame(height: 51.0)
                        }
                        
                        Group {
                            Text("kevin_window_main_details_label".localized())
                                .style(.sectionHeader)
                                .padding(.top, 28)
                                .padding(.bottom, 12)
                            
                            Text("kevin_window_main_email_label".localized())
                                .style(.textFieldName)
                                .padding(.top, 8.0)
                            
                            KevinEmailTextField(text: $viewModel.viewState.email)
                            
                            Text("kevin_window_main_amount_label".localized())
                                .style(.textFieldName)
                                .padding(.top, 20.0)
                            
                            ZStack(alignment: .trailing) {
                                KevinCurrencyTextField(value: $viewModel.viewState.amount)
                                
                                Text("kevin_window_main_amount_field_currency".localized())
                                    .style(.currencyHint)
                                    .padding(.trailing, 14.0)
                            }
                        }
                        
                        KevinAgreementCheckMark(isAgreementChecked: $viewModel.viewState.isAgreementChecked)
                        
                        Button {
                            hideKeyboard()
                            viewModel.openPaymentTypeSelection()
                        } label: {
                            Text(String(
                                format: "kevin_window_main_proceed_button".localized(),
                                KevinFormatter.getCurrencyFormatter().string(from: viewModel.viewState.amount as NSNumber)!,
                                "kevin_window_main_amount_field_currency".localized())
                            ).style(.buttonTitle)
                                .frame(minWidth: 0, maxWidth: .infinity)
                        }
                        .buttonStyle(MainButtonStyle())
                        .disabled(!viewModel.isDonateButtonEnabled)
                    }
                    .frame(
                        minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 0,
                        maxHeight: .infinity,
                        alignment: .topLeading
                    )
                    .padding(16)
                }
            }
            .navigationBarTitle("kevin_window_main_title_label".localized(), displayMode: .large)
        }
        .navigationViewStyle(.stack)
        .halfASheet(
            isPresented: $viewModel.viewState.isCountrySelectorPresented,
            content: {
                KevinCountrySelector(
                    countryCodes: viewModel.viewState.countryCodes,
                    selectedCountry: viewModel.viewState.selectedCountryCode!,
                    onCountrySelected: { selectedCountryCode in
                        viewModel.selectCountry(selectedCountryCode)
                    }
                )
            },
            configuration: HalfASheetConfiguration.defaultProportional
        )
        .halfASheet(
            isPresented: $viewModel.viewState.isPaymentTypeSelectorPresented,
            content: {
                KevinPaymentTypeSelector(
                    onPaymentTypeSelected: { paymentType in
                        viewModel.onPaymentTypeSelected(paymentType)
                    }
                )
            },
            configuration: HalfASheetConfiguration.defaultMinimal
        )
        .halfASheet(
            isPresented: $viewModel.viewState.isLinkedBankSelectorPresented,
            content: {
                KevinLinkedBankSelector(
                    linkedBanks: viewModel.viewState.linkedBanks?.toArray() ?? [],
                    onLinkedBankSelected: { linkedBank in
                        viewModel.onLinkedBankSelected(linkedBank)
                    }
                )
            },
            configuration: HalfASheetConfiguration.defaultMinimal
        )
        .onTapGesture {
            hideKeyboard()
        }
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
