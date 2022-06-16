//
//  KevinAgreementCheckMark.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 11/02/2022.
//

import SwiftUI
import AttributedText

struct KevinAgreementCheckMark: View {
    
    var isAgreementChecked: Bool
    let toggleAgreement: () -> Void
    
    var body: some View {
        return VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Image(systemName: isAgreementChecked ? "checkmark.square.fill" : "square")
                    .foregroundColor(isAgreementChecked ? Color(UIColor.systemBlue) : Color.secondary)
                    .onTapGesture {
                        toggleAgreement()
                    }
                    .padding(.trailing, 4.0)
                
                AttributedText {
                    let result = NSMutableAttributedString(
                        string: String(
                            format: "kevin_window_main_terms_privacy_policy".localized(),
                            "kevin_window_main_terms_privacy_policy_clickable_terms".localized(),
                            "kevin_window_main_terms_privacy_policy_clickable_policy".localized()
                        )
                    )
                    result.addAttributes(
                        [.link: URL(string: "https://www.kevin.eu/docs/EN/terms-and-conditions/")!],
                        range: result.range(of: "kevin_window_main_terms_privacy_policy_clickable_terms".localized())!
                    )
                    result.addAttributes(
                        [.link: URL(string: "https://www.kevin.eu/docs/EN/privacy-policy/")!],
                        range: result.range(of: "kevin_window_main_terms_privacy_policy_clickable_policy".localized())!
                    )
                    result.addAttributes(
                        [
                            .font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular),
                            .foregroundColor: UIColor(TextStyle.agreement.color)
                        ],
                        range: result.range(of: result.string)!
                    )
                    return result
                }
                .accentColor(Color("AccentColor"))
                .padding([.top, .bottom], 16.0)
            }
        }
    }
}
