//
//  KevinCountrySelector.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 14/02/2022.
//

import SwiftUI
import HalfASheet

struct KevinCountrySelector: View {
    
    private let countyCodes: [String]
    private let onCountrySelected: (String) -> Void

    init(
        countyCodes: [String],
        onCountrySelected: @escaping (String) -> Void
    ) {
        self.countyCodes = countyCodes
        self.onCountrySelected = onCountrySelected
    }
    
    var body: some View {
        return GeometryReader { geoReader in
            ScrollView {
                VStack {
                    ForEach(countyCodes, id: \.self) { countyCode in
                        Button(action: {
                            onCountrySelected(countyCode)
                        }) {
                            HStack(spacing: 0.0) {
                                Image("flag\(countyCode)")
                                    .resizable()
                                    .frame(width: 40.0, height: 40.0)
                                    .padding()

                                Text("country_name_\(countyCode)".lowercased().localized())
                                    .foregroundColor(Color("PrimaryTextColor"))

                                Spacer()
                            }
                        }
                    }
                }
                .frame(width: geoReader.size.width)
            }
        }
    }
}
