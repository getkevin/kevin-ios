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
                            HStack {
                                Image("flag\(countyCode)")
                                    .padding()

                                Text("country_name_\(countyCode)".lowercased().localized())
                                    .foregroundColor(Color.black)

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
