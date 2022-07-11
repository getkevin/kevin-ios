//
//  KevinEmailTextField.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 11/02/2022.
//

import SwiftUI

struct KevinEmailTextField: View {
    
    @Binding var text: String
    
    var body: some View {
        TextField("", text: $text)
            .textContentType(.emailAddress)
            .keyboardType(.emailAddress)
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
