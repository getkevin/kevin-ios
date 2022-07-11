//
//  StyleModifier.swift
//  KevinDemo
//
//  Created by Edgar Žigis on 2022-02-26.
//

import Foundation
import SwiftUI

struct StyleModifier: ViewModifier {
    
    var style: TextStyle

    func body(content: Content) -> some View {
        content
            .font(style.font)
            .foregroundColor(style.color)
    }
}
