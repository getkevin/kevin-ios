//
//  KevinSelectionRowView.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 09/02/2022.
//

import SwiftUI

struct KevinSelectionRowView<Value>: View where Value : View {
    
    private let title: String
    private let value: Value?
    private let chevronVisible: Bool
    
    init(
        title: String,
        value: Value?,
        showChevron: Bool = true
    ) {
        self.title = title
        self.value = value
        self.chevronVisible = showChevron
    }
    
    var body: some View {
        HStack {
            Text("\(title)")
                .style(.selectionText)

            Spacer()
            
            if let _value = value {
                _value
            }
            
            if chevronVisible {
                Image(systemName: "chevron.right")
                    .frame(width: 8.0, height: 14.0, alignment: .center)
                    .foregroundColor(Color.init("SecondaryTextColor"))
            }
        }
        .padding([.top, .bottom], 18.0)
        .padding(.leading, 16.0)
        .padding(.trailing, 20.0)
        .background(Color.white)
        .cornerRadius(11)
    }
}
