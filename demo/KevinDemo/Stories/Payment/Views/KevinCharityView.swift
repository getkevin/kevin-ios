//
//  KevinCharityView.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 14/02/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct KevinCharityView: View {
    
    private let logoUrlString: String
    private let isSelected: Bool
    private let onTap: () -> Void

    init(
        logoUrlString: String,
        isSelected: Bool,
        onTap: @escaping () -> Void
    ) {
        self.logoUrlString = logoUrlString
        self.isSelected = isSelected
        self.onTap = onTap
    }
    
    var body: some View {
        let width = (UIScreen.main.bounds.size.width - 16 * 4) / 3
        let borderColor = isSelected ? Color("AccentColor") : Color("GreyAccentColor")
        let borderWidth = isSelected ? 2.0 : 1.0

        WebImage(url: URL(string: logoUrlString))
            .resizable()
            .indicator(.activity)
            .transition(.fade(duration: 0.5))
            .scaledToFit()
            .padding(9.0)
            .frame(width: width, height: 51.0)
            .background(Color("SecondaryBackgroundColor"))
            .cornerRadius(11.0)
            .overlay(
                RoundedRectangle(cornerRadius: 11)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .onTapGesture {
                onTap()
            }
    }
}
