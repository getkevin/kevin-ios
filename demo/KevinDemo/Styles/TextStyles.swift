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
    case segmentedPickerSelected
    case segmentedPickerUnselected
    case sectionHeader
    case textFieldName
    case currencyHint
    case agreement
    case agreementLink
    case buttonTitle
    case countrySelectorTitle
    case countrySelectorItemTitle

    public var font: Font {
        switch self {
        case .title:
            return .system(size: 34).weight(.semibold)
        case .subtitle:
            return .system(size: 16).weight(.regular)
        case .segmentedPickerSelected:
            return .system(size: 16).weight(.medium)
        case .segmentedPickerUnselected:
            return .system(size: 16).weight(.medium)
        case .sectionHeader:
            return .system(size: 17).weight(.semibold)
        case .textFieldName:
            return .system(size: 14).weight(.regular)
        case .currencyHint:
            return .system(size: 14).weight(.regular)
        case .agreement,
             .agreementLink:
            return .system(size: 12).weight(.regular)
        case .buttonTitle:
            return .system(size: 17).weight(.semibold)
        case .countrySelectorTitle:
            return .system(size: 21).weight(.medium)
        case .countrySelectorItemTitle:
            return .system(size: 16).weight(.semibold)
        }
    }
    
    public var textCase: Text.Case? {
        switch self {
        default:
            return nil
        }
    }
    
    public var color: Color {
        switch self {
        case .subtitle,
             .currencyHint,
             .textFieldName,
             .segmentedPickerUnselected:
            return Color.init("SecondaryTextColor")
        case .agreementLink:
            return Color.init("AccentColor")
        case .buttonTitle:
            return Color.white
        default:
            return Color.init("PrimaryTextColor")
        }
    }
}
