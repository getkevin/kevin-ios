//
//  KevinCountrySelectionCell.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 09/02/2022.
//

import SwiftUI

struct KevinCountrySelectionCell: View {
    
    private let title: String
    private let countryCode: String?
    private let chevronVisible: Bool
    
    init(
        title: String,
        countryCode: String?,
        showChevron: Bool = true
    ) {
        self.title = title
        self.countryCode = countryCode
        self.chevronVisible = showChevron
    }
    
    var body: some View {
        HStack {
            if let countryCode = countryCode {
                Image("flag\(countryCode)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30.0, height: 30.0)
                    .padding(.vertical, 4.0)

                Text("\(title)")
                    .style(.countrySelectorItemTitle)

                Spacer()
     
                Text("kevin_country_name_\(countryCode)".lowercased().localized())
                    .style(.countrySelectorItemTitle)
                    .padding(.trailing, 16.0)
            } else {
                Spacer()
                
                ProgressView()
                    .frame(height: 38.0)

                Spacer()
            }
            
            if chevronVisible {
                Image("chevronIcon")
                    .frame(width: 8.0, height: 14.0, alignment: .center)
                    .foregroundColor(Color.gray)
            }
        }
        .padding(.vertical, 8.0)
        .padding(.leading, 16.0)
        .padding(.trailing, 20.0)
        .background(Color("SecondaryBackgroundColor"))
        .cornerRadius(11)
    }
}
