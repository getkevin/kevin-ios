//
//  KevinPaymentTypeSelector.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 15/06/2022.
//

import SwiftUI
import HalfASheet

struct KevinPaymentTypeSelector: View {
    
    private let onPaymentTypeSelected: (PaymentType) -> Void
    
    init(onPaymentTypeSelected: @escaping (PaymentType) -> Void) {
        self.onPaymentTypeSelected = onPaymentTypeSelected
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("kevin_window_payment_type_title".localized())
                .style(.countrySelectorTitle)
            
            VStack {
                ForEach(PaymentType.allCases, id: \.self) { paymentType in
                    Button(action: {
                        onPaymentTypeSelected(paymentType)
                    }) {
                        HStack(spacing: 0.0) {
                            paymentType.icon
                                .resizable()
                                .frame(width: 40.0, height: 40.0)
                                .padding(.horizontal)
                                .padding(.vertical, 12.0)
                            
                            Text(paymentType.title)
                                .foregroundColor(Color("PrimaryTextColor"))
                                .style(.cellTitle)
                            
                            Spacer()
                            
                            Image("chevronIcon")
                                .frame(width: 8.0, height: 14.0, alignment: .center)
                                .foregroundColor(Color.gray)
                                .padding(.trailing)
                        }
                    }.background(Color("SecondaryBackgroundColor"))
                }
            }
            .background(Color("SecondaryBackgroundColor"))
            .cornerRadius(15)
        }
    }
}
