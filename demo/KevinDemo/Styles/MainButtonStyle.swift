//
//  MainButtonStyle.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 13/06/2022.
//

import SwiftUI

public struct MainButtonStyle: ButtonStyle {
    
    public init() { }

    public func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        MainButton(configuration: configuration)
    }

    struct MainButton: View {
        let configuration: ButtonStyle.Configuration
        
        @Environment(\.isEnabled) private var isEnabled: Bool
        
        var body: some View {
            configuration.label
                .font(TextStyle.buttonTitle.font)
                .padding(.vertical)
                .padding(.horizontal, 30.0)
                .background(isEnabled ? Color("AccentColor") : Color("DisabledButton"))
                .foregroundColor(Color.white)
                .cornerRadius(8)
                .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
        }
    }
}
