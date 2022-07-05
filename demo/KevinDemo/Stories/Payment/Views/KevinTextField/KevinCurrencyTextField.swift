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
    @State private var isInternalChange = false
    private let allowedCharacters: CharacterSet = .decimalDigitsWithSeparator
    private let maxLenghtInCharacters = 12

    init(value: Binding<Double>) {
        self._value = value
    }
    
    var body: some View {
        TextField("", text: $text)
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
                text = String(newValue.prefix(maxLenghtInCharacters).unicodeScalars.filter(allowedCharacters.contains))
                
                let decimalValue = KevinFormatter.getDecimalFormatter().number(from: text) ?? 0
                value = Double(truncating: decimalValue)
            }
            .onChange(of: value) { newValue in
                if value == 0 {
                    text = ""
                } else {
                    text = KevinFormatter.getDecimalFormatter().string(from: newValue as NSNumber) ?? ""
                }
            }
    }
}
