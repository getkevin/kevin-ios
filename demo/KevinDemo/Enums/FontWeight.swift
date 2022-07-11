//
//  FontWeight.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 15/06/2022.
//

import SwiftUI

public enum FontWeight {
    case ultraLight
    case thin
    case light
    case regular
    case medium
    case semibold
    case bold
    case heavy
    case black
    
    public var fontWeight: Font.Weight {
        switch self {
        case .ultraLight: return Font.Weight.ultraLight
        case .thin: return Font.Weight.thin
        case .light: return Font.Weight.light
        case .regular: return Font.Weight.regular
        case .medium: return Font.Weight.medium
        case .semibold: return Font.Weight.semibold
        case .bold: return Font.Weight.bold
        case .heavy: return Font.Weight.heavy
        case .black: return Font.Weight.black
        }
    }
    
    public var uiFontWeight: UIFont.Weight {
        switch self {
        case .ultraLight: return UIFont.Weight.ultraLight
        case .thin: return UIFont.Weight.thin
        case .light: return UIFont.Weight.light
        case .regular: return UIFont.Weight.regular
        case .medium: return UIFont.Weight.medium
        case .semibold: return UIFont.Weight.semibold
        case .bold: return UIFont.Weight.bold
        case .heavy: return UIFont.Weight.heavy
        case .black: return UIFont.Weight.black
        }
    }
}
