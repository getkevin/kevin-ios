//
//  KevinTextField.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 11/02/2022.
//

import SwiftUI

struct KevinTextField: View {
    
    @Binding var text: String
    var type: KevinTextFieldType
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("", text: $text)
                .onChange(of: text) { _ in
                    if type == .amount {
                        text = text.toCurrencyFormat()
                    }
                }
                .textContentType(type.textContentType)
                .keyboardType(type.keyboardType)
                .autocapitalization(UITextAutocapitalizationType.none)
                .disableAutocorrection(true)
                .padding(12.0)
                .background(Color("SecondaryBackgroundColor"))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("GreyAccentColor"))
                )
        }
    }
}
