//
//  AccountsView.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 10/06/2022.
//

import SwiftUI

public struct AccountsView: View {
    
    private let linkedBanks: [LinkedBank]
    private let linkBank: () -> Void
    private let deleteBank: (LinkedBank) -> Void

    public init(
        linkedBanks: [LinkedBank],
        linkBank: @escaping () -> Void,
        deleteBank: @escaping (LinkedBank) -> Void
    ) {
        self.linkedBanks = linkedBanks
        self.linkBank = linkBank
        self.deleteBank = deleteBank
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                NewAccountCell(linkBank: linkBank)

                Text("kevin_window_link_account_linked_accounts_label".localized())
                    .style(.sectionHeader)
                    .padding(.top, 28)
                    .padding(.bottom, 12)
                
                VStack(spacing: 1) {
                    ForEach(linkedBanks, id: \.bankId) { linkedBank in
                        AccountCell(
                            linkedBank: linkedBank,
                            deleteBank: deleteBank
                        )
                    }
                }
                .cornerRadius(8)
            }
            .padding([.top, .horizontal])
            .listStyle(.insetGrouped)
        }
    }
}
