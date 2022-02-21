//
//  View+Extensions.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 10/02/2022.
//

import SwiftUI

extension View {
    public func toAnyView() -> AnyView {
        return AnyView(self)
    }
}
