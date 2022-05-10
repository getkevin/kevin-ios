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
            Text("window_main_title_label".localized())
                .style(.title)
                .padding(.top, 16)
                .padding(.bottom, 0)
            Text("window_main_subtitle_label".localized())
                .style(.subtitle)
                .padding(.top, 0)
        }
    }
}
