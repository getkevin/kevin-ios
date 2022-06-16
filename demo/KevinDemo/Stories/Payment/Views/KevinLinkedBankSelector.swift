//
//  KevinLinkedBankSelector.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 16/06/2022.
//

import SwiftUI
import HalfASheet
import SDWebImageSwiftUI

struct KevinLinkedBankSelector: View {
    
    private let linkedBanks: [LinkedBank]
    private let onLinkedBankSelected: (LinkedBank) -> Void

    init(
        linkedBanks: [LinkedBank],
        onLinkedBankSelected: @escaping (LinkedBank) -> Void
    ) {
        self.linkedBanks = linkedBanks
        self.onLinkedBankSelected = onLinkedBankSelected
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("kevin_window_choose_account_title".localized())
                .style(.countrySelectorTitle)
            
            VStack {
                ForEach(linkedBanks, id: \.self) { linkedBank in
                    Button(action: {
                        onLinkedBankSelected(linkedBank)
                    }) {
                        HStack(spacing: 0.0) {
                            WebImage(url: URL(string: linkedBank.bankImageUrl))
                                .resizable()
                                .indicator(.activity)
                                .transition(.fade(duration: 0.5))
                                .scaledToFit()
                                .frame(width: 40.0, height: 40.0)
                                .padding([.leading, .trailing])
                                .padding([.top, .bottom], 12.0)

                            Text(linkedBank.bankName)
                                .foregroundColor(Color("PrimaryTextColor"))
                                .style(.cellTitle)

                            Spacer()

                            Image("chevronIcon")
                                .frame(width: 8.0, height: 14.0, alignment: .center)
                                .foregroundColor(Color.gray)
                                .padding(.trailing)
                        }
                    }.background(Color("SecondaryBackgroundColor"))
                }
            }
            .background(Color("SecondaryBackgroundColor"))
            .cornerRadius(15)
        }
    }
}
