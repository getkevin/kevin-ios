//
//  MainButtonStyle.swift
//  KevinDemo
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import SwiftUI

struct MainButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .font(.system(size: 15, weight: .semibold))
            .padding()
            .background(Color(.sRGB, red: 100/255, green: 127/255, blue: 246/255, opacity: 1))
            .foregroundColor(Color.white)
            .cornerRadius(8)
            .shadow(radius: 4)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
