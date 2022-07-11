//
//  KevinLinkedBankSelector.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 16/06/2022.
//

import SwiftUI
import HalfASheet

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
                        KevinLinkedBankCell(linkedBank: linkedBank)
                    }.background(Color("SecondaryBackgroundColor"))
                }
            }
            .background(Color("SecondaryBackgroundColor"))
            .cornerRadius(15)
        }
    }
}
