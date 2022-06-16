//
//  NewAccountCell.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 14/06/2022.
//

import SwiftUI

struct NewAccountCell: View {
    
    private let linkBank: () -> Void

    public init(linkBank: @escaping () -> Void) {
        self.linkBank = linkBank
    }
    
    var body: some View {
        HStack(alignment: .top) {
            Image("Plus")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
            
            Text("kevin_window_link_account_link_new_button".localized())
                .style(.action)
                .frame(maxHeight: .infinity)
            
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color("SecondaryBackgroundColor"))
        .cornerRadius(8.0)
        .onTapGesture {
            linkBank()
        }
    }
}
