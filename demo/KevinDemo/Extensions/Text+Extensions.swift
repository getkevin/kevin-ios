//
//  Text+Extensions.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 04/01/2022.
//

import SwiftUI

struct Style: ViewModifier {
    var style: TextStyle

    func body(content: Content) -> some View {
        content
            .font(style.font)
            .foregroundColor(style.color)
            .textCase(style.textCase)
    }
}

extension Text {
    public func style(_ style: TextStyle) -> some View {
        modifier(Style(style: style))
    }
}
