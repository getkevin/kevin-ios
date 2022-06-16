//
//  AccountCell.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 14/06/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct AccountCell: View {
    
    private let linkedBank: LinkedBank
    private let deleteBank: (LinkedBank) -> Void

    public init(
        linkedBank: LinkedBank,
        deleteBank: @escaping (LinkedBank) -> Void
    ) {
        self.linkedBank = linkedBank
        self.deleteBank = deleteBank
    }
    
    var body: some View {
        HStack(alignment: .center) {
            WebImage(url: URL(string: linkedBank.bankImageUrl))
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .scaledToFit()
                .frame(width: 40)
                .padding(16)
            
            Text(linkedBank.bankName)
                .style(.cellTitle)
                .frame(maxHeight: .infinity)
            
            Spacer()
            
            Menu {
                if #available(iOS 15.0, *) {
                    Button(role: .destructive) {
                        deleteBank(linkedBank)
                    } label: {
                        Label("kevin_window_account_actions_remove".localized(), systemImage: "trash")
                    }
                } else {
                    Button {
                        deleteBank(linkedBank)
                    } label: {
                        Label("kevin_window_account_actions_remove".localized(), systemImage: "trash")
                    }
                }
            } label: {
                Image("Menu")
                    .padding(16)
            }
        }
        .background(Color("SecondaryBackgroundColor"))
    }
}
