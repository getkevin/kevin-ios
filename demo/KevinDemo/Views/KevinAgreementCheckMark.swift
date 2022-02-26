//
//  KevinAgreementCheckMark.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 11/02/2022.
//

import SwiftUI

struct KevinAgreementCheckMark: View {
    
    var isAgreementChecked: Bool
    let toggleAgreement: () -> Void
    let openLink: (String) -> Void
    
    var body: some View {
        return VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Image(systemName: isAgreementChecked ? "checkmark.square.fill" : "square")
                    .foregroundColor(isAgreementChecked ? Color(UIColor.systemBlue) : Color.secondary)
                    .onTapGesture {
                        toggleAgreement()
                    }
                    .padding(.trailing, 4.0)

                TextLabelWithHyperLink(
                    linkTintColor: UIColor(TextStyle.agreementLink.color),
                    string: String(
                        format: "agreement_checkmark".localized(),
                        "terms_and_conditions".localized(),
                        "privacy_policy".localized()
                    ),
                    attributes: [
                        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular),
                        NSAttributedString.Key.foregroundColor: UIColor(TextStyle.agreement.color)
                    ],
                    hyperLinkItems: [
                        .init(
                            subText: "terms_and_conditions".localized(),
                            url: "https://www.kevin.eu/docs/EN/terms-and-conditions/"
                        ),
                        .init(
                            subText: "privacy_policy".localized(),
                            url: "https://www.kevin.eu/docs/EN/privacy-policy/"
                        )
                    ],
                    openLink: { linkItem in
                        openLink(linkItem.url)
                    }
                ).padding([.top, .bottom], 16.0)
            }
        }
    }
}
