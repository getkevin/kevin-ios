//
//  TextStyles.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 08/02/2022.
//

import SwiftUI

public enum TextStyle {
    case title
    case subtitle
    case action
    case sectionHeader
    case textFieldName
    case currencyHint
    case agreement
    case agreementLink
    case buttonTitle
    case countrySelectorTitle
    case countrySelectorItemTitle
    case cellTitle

    private var size: CGFloat {
        switch self {
        case .title: return 22
        case .subtitle: return 16
        case .action: return 16
        case .sectionHeader: return 17
        case .textFieldName: return 14
        case .currencyHint: return 14
        case .agreement: return 12
        case .agreementLink: return 12
        case .buttonTitle: return 17
        case .countrySelectorTitle: return 21
        case .countrySelectorItemTitle: return 16
        case .cellTitle: return 16
        }
    }
    
    private var weight: FontWeight {
        switch self {
        case .title: return .semibold
        case .subtitle: return .regular
        case .action: return .medium
        case .sectionHeader: return .semibold
        case .textFieldName: return .regular
        case .currencyHint: return .regular
        case .agreement: return .regular
        case .agreementLink: return .regular
        case .buttonTitle: return .semibold
        case .countrySelectorTitle: return .medium
        case .countrySelectorItemTitle: return .semibold
        case .cellTitle: return .medium
        }
    }
    
    public var font: Font {
        return Font.system(size: size).weight(weight.fontWeight)
    }
    
    public var uiFont: UIFont {
        return UIFont.systemFont(ofSize: size, weight: weight.uiFontWeight)
    }

    public var color: Color {
        switch self {
        case .subtitle,
             .currencyHint,
             .textFieldName:
            return Color("SecondaryTextColor")
        case .action,
             .agreementLink:
            return Color("AccentColor")
        case .buttonTitle:
            return Color.white
        default:
            return Color("PrimaryTextColor")
        }
    }
    
    public var uiColor: UIColor {
        return UIColor(color)
    }
    
    public var asAttributes: [NSAttributedString.Key: Any] {
        return [
            .font: uiFont,
            .foregroundColor: UIColor(color)
        ]
    }
}
