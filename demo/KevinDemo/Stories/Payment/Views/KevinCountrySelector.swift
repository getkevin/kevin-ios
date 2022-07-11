//
//  KevinCountrySelector.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 14/02/2022.
//

import SwiftUI
import HalfASheet

struct KevinCountrySelector: View {
    
    private let countryCodes: [String]
    private let selectedCountry: String
    private let onCountrySelected: (String) -> Void

    init(
        countryCodes: [String],
        selectedCountry: String,
        onCountrySelected: @escaping (String) -> Void
    ) {
        self.countryCodes = countryCodes
        self.selectedCountry = selectedCountry
        self.onCountrySelected = onCountrySelected
    }
    
    var body: some View {
        return GeometryReader { geometryReader in
            VStack(alignment: .leading) {
                Text("kevin_window_main_country_label".localized())
                    .style(.countrySelectorTitle)
                
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForEach(countryCodes, id: \.self) { countryCode in
                            let isCountrySelected = countryCode == selectedCountry
                            Button(action: {
                                onCountrySelected(countryCode)
                            }) {
                                HStack(spacing: 0.0) {
                                    Image("flag\(countryCode)")
                                        .resizable()
                                        .frame(width: 40.0, height: 40.0)
                                        .padding(.horizontal)
                                        .padding(.vertical, 12.0)

                                    Text("kevin_country_name_\(countryCode)".lowercased().localized())
                                        .foregroundColor(Color("PrimaryTextColor"))
                                        .style(.countrySelectorItemTitle)

                                    Spacer()
                                    
                                    Image("chevronIcon")
                                        .frame(width: 8.0, height: 14.0, alignment: .center)
                                        .foregroundColor(Color.gray)
                                        .padding(.trailing)
                                }
                            }.background(Color(isCountrySelected ? "AccentColor" : "SecondaryBackgroundColor"))
                        }
                    }
                    .frame(width: geometryReader.size.width)
                    .background(Color("SecondaryBackgroundColor"))
                    .cornerRadius(15)
                }
            }
        }
    }
}
