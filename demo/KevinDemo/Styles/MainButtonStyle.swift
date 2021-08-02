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
            .font(.system(size: 15))
            .padding()
            .background(Color.blue)
            .foregroundColor(Color.white)
            .cornerRadius(32)
            .shadow(radius: 4)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
