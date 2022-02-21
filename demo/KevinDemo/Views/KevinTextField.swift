//
//  KevinTextField.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 11/02/2022.
//

import SwiftUI

struct KevinTextField: View {
    let onChange: () -> Void
    let textBinding: Binding<String>
    let text: String
    var textContentType: UITextContentType? = nil
    let keyboardType: UIKeyboardType

    var body: some View {
        return VStack(alignment: .leading) {
            TextField("", text: textBinding)
                .onChange(of: text) { _ in
                    onChange()
                }
                .textContentType(textContentType)
                .keyboardType(keyboardType)
                .padding(12.0)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.init("GreyAccentColor"))
                )
        }
    }
}


