//
//  Kevin.swift
//  kevin.iOS
//
//  Created by Kacper Dziubek on 28/06/2023.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation
import UIKit

internal struct FrameCustomisationHelper {
    static func appendUrlParameters(urlString: String) -> URL {
        let queryItems = [
            URLQueryItem(name: "lang", value: Kevin.shared.locale.identifier.lowercased()),
            URLQueryItem(name: "cs", value: customStyleJsonString)
        ]
        var urlComponents = URLComponents(string: urlString)!
        urlComponents.queryItems = queryItems
        let result = urlComponents.url!

        return result
    }

    private static var customStyleJsonString: String {
        let theme = Kevin.shared.theme
        let customStyle = CustomStyle(
            backgroundColor: theme.generalStyle.primaryBackgroundColor.hexString,
            baseColor: theme.generalStyle.primaryBackgroundColor.hexString,
            headingsColor: theme.generalStyle.primaryTextColor.hexString,
            fontColor: theme.generalStyle.primaryTextColor.hexString,
            bankIconColor: UIApplication.shared.isLightThemedInterface ? "default" : "white",
            defaultButtonColor: theme.mainButtonStyle.backgroundColor.hexString,
            defaultButtonFontColor: theme.mainButtonStyle.titleLabelTextColor.hexString,
            buttonRadius: "\(theme.mainButtonStyle.cornerRadius)px",
            inputBorderColor: theme.generalStyle.primaryTextColor.hexString,
            customLayout: ["hl"]
        )

        let jsonData = try! JSONEncoder().encode(customStyle)
        return String(data: jsonData, encoding: String.Encoding.utf8)!
    }

    private struct CustomStyle: Encodable {
        let backgroundColor: String
        let baseColor: String
        let headingsColor: String
        let fontColor: String
        let bankIconColor: String
        let defaultButtonColor: String
        let defaultButtonFontColor: String
        let buttonRadius: String
        let inputBorderColor: String
        let customLayout: [String]

        enum CodingKeys: String, CodingKey {
            case backgroundColor = "bc"
            case baseColor = "bsc"
            case headingsColor = "hc"
            case fontColor = "fc"
            case bankIconColor = "bic"
            case defaultButtonColor = "dbc"
            case defaultButtonFontColor = "dbfc"
            case buttonRadius = "br"
            case inputBorderColor = "ibc"
            case customLayout = "cl"
        }
    }
}
