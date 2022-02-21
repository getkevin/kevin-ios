//
//  UIApplication+Extensions.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 10/02/2022.
//

import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
