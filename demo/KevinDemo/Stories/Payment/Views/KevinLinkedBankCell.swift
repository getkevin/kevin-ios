//
//  KevinLinkedBankCell.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 21/06/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct KevinLinkedBankCell: View {
    
    private let linkedBank: LinkedBank

    init(linkedBank: LinkedBank) {
        self.linkedBank = linkedBank
    }
    
    var body: some View {
        HStack(spacing: 0.0) {
            WebImage(url: URL(string: linkedBank.bankImageUrl))
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .scaledToFit()
                .frame(width: 40.0, height: 40.0)
                .padding(.horizontal)
                .padding(.vertical, 12.0)

            Text(linkedBank.bankName)
                .foregroundColor(Color("PrimaryTextColor"))
                .style(.cellTitle)

            Spacer()

            Image("chevronIcon")
                .frame(width: 8.0, height: 14.0, alignment: .center)
                .foregroundColor(Color.gray)
                .padding(.trailing)
        }
    }
}
