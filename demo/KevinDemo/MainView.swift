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
import HalfASheet

struct MainView: View {
    
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                Color("PrimaryBackgroundColor").ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading) {
                        KevinScreenTitle()
                        
                        SegmentedControlView(
                            selectedValue: $viewModel.viewState.selectedPaymentType,
                            elements: [
                                SegmentedControlElement(
                                    title: "window_main_bank_payment".localized(),
                                    value: PaymentType.bank
                                ),
                                SegmentedControlElement(
                                    title: "window_main_card_payment".localized(),
                                    value: PaymentType.card
                                )
                            ]
                        )
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding(.top, 24.0)
                        .padding(.bottom, 32.0)
                        
                        Section(
                            header: Text("window_main_country_charity_label".localized())
                                .style(.sectionHeader)
                                .frame(
                                    width: reader.size.width,
                                    height: 0.0,
                                    alignment: .leading
                                )
                        ) {
                            Button(action: {
                                viewModel.openCountrySelection()
                            }) {
                                KevinCountrySelectionRowView(
                                    title: "window_main_country_label".localized(),
                                    countryCode: viewModel.viewState.selectedCountryCode
                                )
                            }
                                          
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
                        .padding(.bottom, 14.0)
                        
                        Section(
                            header: Text("window_main_details_lable".localized())
                                .style(.sectionHeader)
                                .frame(
                                    width: reader.size.width,
                                    height: 20.0,
                                    alignment: .leading
                                )
                                .padding(.top, 8.0)
                        ) {
                            Text("window_main_email_label".localized())
                                .style(.textFieldName)
                                .padding(.top, 8.0)
                            
                            KevinTextField(
                                onChange: {
                                    viewModel.updateDonateButtonState()
                                },
                                textBinding: $viewModel.viewState.email,
                                text: viewModel.viewState.email,
                                textContentType: .emailAddress,
                                keyboardType: .emailAddress
                            )
                            
                            Text("window_main_amount_label".localized())
                                .style(.textFieldName)
                                .padding(.top, 20.0)
                            
                            ZStack(alignment: .trailing) {
                                KevinTextField(
                                    onChange: {
                                        viewModel.viewState.amountString = viewModel.viewState.amountString.toCurrencyFormat()
                                        viewModel.updateDonateButtonState()
                                    },
                                    textBinding: $viewModel.viewState.amountString,
                                    text: viewModel.viewState.amountString,
                                    keyboardType: .decimalPad
                                )
                                
                                Text("window_main_amount_field_currency".localized())
                                    .style(.currencyHint)
                                    .padding(.trailing, 14.0)
                            }
                        }
                        
                        KevinAgreementCheckMark(
                            isAgreementChecked: viewModel.viewState.isAgreementChecked,
                            toggleAgreement: {
                                viewModel.toggleAgreement()
                            },
                            openLink: { linkString in
                                viewModel.openAgreementLink(linkString)
                            }
                        )
                        
                        Button(action: {
                            hideKeyboard()
                            viewModel.makeDonation()
                        }) {
                            Text(String(
                                format: "window_main_proceed_button".localized(),
                                viewModel.viewState.amountString,
                                "window_main_amount_field_currency".localized())
                            ).style(.buttonTitle)
                        }
                        .frame(
                            minWidth: 200,
                            maxWidth: .infinity,
                            minHeight: 48.0,
                            maxHeight: 48.0,
                            alignment: .center
                        )
                        .background(viewModel.viewState.isDonateButtonDisabled ? Color("DisabledButton") : Color("AccentColor"))
                        .cornerRadius(10)
                        .disabled(viewModel.viewState.isDonateButtonDisabled)
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
        }
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
            configuration: HalfASheetConfiguration(
                appearanceAnimationDuration: 0.2,
                backgroundColor: Color("PrimaryBackgroundColor"),
                height: .proportional(0.85),
                contentInsets: EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16),
                allowsDraggingToDismiss: true
            )
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
                dismissButton: .default(Text("dialog_payment_success_button".localized()))
            )
        })
    }
}
