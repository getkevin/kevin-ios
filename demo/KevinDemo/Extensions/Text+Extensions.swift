//
//  Text+Extensions.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 04/01/2022.
//

import SwiftUI

extension Text {
    
    public func style(_ style: TextStyle) -> some View {
        modifier(StyleModifier(style: style))
    }
}
