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
                Color.init("PrimaryBackgroundColor").ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading) {
                        KevinScreenTitle()
                        
                        SegmentedControlView(
                            selectedValue: $viewModel.viewState.selectedPaymentType,
                            elements: [
                                SegmentedControlElement(
                                    title: "payment_type_bank".localized(),
                                    value: PaymentType.bank
                                ),
                                SegmentedControlElement(
                                    title: "payment_type_card".localized(),
                                    value: PaymentType.card
                                )
                            ]
                        )
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding(.top, 24.0)
                        .padding(.bottom, 32.0)
                        
                        Section(
                            header: Text("country_section_title".localized())
                                .style(.sectionHeader)
                                .frame(
                                    width: reader.size.width,
                                    alignment: .leading
                                )
                        ) {
                            Button(action: {
                                viewModel.presentCountrySelector()
                            }) {
                                KevinCountrySelectionRowView(
                                    title: "country".localized(),
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
                            header: Text("details_section_title".localized())
                                .style(.sectionHeader)
                                .frame(
                                    width: reader.size.width,
                                    height: 50,
                                    alignment: .leading
                                )
                        ) {
                            Text("email".localized())
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
                            
                            Text("amount".localized())
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
                                    keyboardType: .numberPad
                                )
                                
                                Text("currency_eur".localized())
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
                                viewModel.openLink(linkString)
                            }
                        )
                        
                        Button(action: {
                            hideKeyboard()
                            viewModel.onDonateButtonTapped()
                        }) {
                            Text(String(
                                format: "donate_button_title".localized(),
                                viewModel.viewState.amountString,
                                "currency_eur".localized())
                            ).style(.buttonTitle)
                        }
                        .frame(
                            minWidth: 200,
                            maxWidth: .infinity,
                            minHeight: 48.0,
                            maxHeight: 48.0,
                            alignment: .center
                        )
                        .background(viewModel.viewState.isDonateButtonDisabled ? Color.init("DisabledButton") : Color.init("AccentColor"))
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
                    countyCodes: viewModel.viewState.countryCodes,
                    onCountrySelected: { selectedCountryCode in
                        viewModel.onCounrtyCodeSelected(selectedCountryCode)
                    }
                )
            },
            configuration: HalfASheetConfiguration(
                appearanceAnimationDuration: 0.2,
                backgroundColor: .white,
                height: .proportional(0.7),
                contentInsets: EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0),
                allowsDraggingToDismiss: false,
                allowsButtonDismiss: false
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
                dismissButton: .default(Text("action_ok".localized()))
            )
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        MainView(viewModel: MainViewModel())
    }
}
