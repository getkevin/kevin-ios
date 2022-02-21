//
//  KevinScreenTitle.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 11/02/2022.
//

import SwiftUI

struct KevinScreenTitle: View {
    var body: some View {
        return VStack(alignment: .leading) {
            Text("screen_title".localized())
                .style(.title)
                .padding(.top, 16.0)
                .padding(.bottom, 3.0)
            
            Text("screen_subtitle".localized())
                .style(.subtitle)
                .padding(.top, 0)
        }
    }
}
