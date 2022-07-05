//
//  KevinCurrencyTextField.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 04/07/2022.
//

import SwiftUI

struct KevinCurrencyTextField: View {
    
    @Binding var value: Double
    @State var text: String = ""
    
    init(value: Binding<Double>) {
        self._value = value
    }
    
    var body: some View {
        KevinBaseTextField("", text: $text, allowed: .decimalDigitsWithSeparator)
            .keyboardType(.decimalPad)
            .autocapitalization(UITextAutocapitalizationType.none)
            .disableAutocorrection(true)
            .padding(12.0)
            .background(Color("SecondaryBackgroundColor"))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("GreyAccentColor"))
            )
            .onChange(of: text) { newValue in
                let decimalValue = KevinFormatter.getDecimalFormatter().number(from: newValue) ?? 0
                value = Double(truncating: decimalValue)
            }
    }
}
