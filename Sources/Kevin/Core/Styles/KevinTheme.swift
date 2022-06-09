//
//  KevinTheme.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation
import UIKit

open class KevinTheme {
    
    public struct Insets {
        public var left: CGFloat = 16
        public var top: CGFloat = 24
        public var right: CGFloat = 16
        public var bottom: CGFloat = 25
        
        public init() { }
    }
    
    public struct GeneralStyle {
        public var primaryBackgroundColor = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
        public var primaryTextColor = UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1)
        public var secondaryTextColor = UIColor(red: 124/255, green: 136/255, blue: 148/255, alpha: 1)
        public var actionTextColor = UIColor.systemBlue
        public var primaryFont = UIFont.systemFont(ofSize: 23, weight: .bold)
        public var secondaryFont = UIFont.systemFont(ofSize: 14, weight: .regular)

        public init() { }
    }
    
    public struct NavigationBarStyle {
        public var titleColor = UIColor.white
        public var tintColor = UIColor.white
        public var backgroundColorLightMode = UIColor(red: 1, green: 0, blue: 32/255, alpha: 1)
        public var backgroundColorDarkMode = UIColor(red: 1, green: 0, blue: 32/255, alpha: 1)
        public var backButtonImage = UIImage(named: "backButtonIcon", in: Bundle.module, compatibleWith: nil)
        public var closeButtonImage = UIImage(named: "closeButtonIcon", in: Bundle.module, compatibleWith: nil)
        
        public init() { }
    }
    
    public struct SheetPresentationStyle {
        public var dragIndicatorTintColor = UIColor(red: 190/255, green: 196/255, blue: 203/255, alpha: 1)
        public var backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
        public var titleLabelFont = UIFont.systemFont(ofSize: 21, weight: .medium)
        public var cornerRadius: CGFloat = 10
        
        public init() { }
    }
    
    public struct SectionStyle {
        public var titleLabelFont = UIFont.systemFont(ofSize: 13, weight: .semibold)
        
        public init() { }
    }
    
    public struct GridTableStyle {
        public var cellBackgroundColor = UIColor.white
        public var cellSelectedBackgroundColor = UIColor(red: 226/255, green: 225/255, blue: 234/255, alpha: 1)
        public var cellCornerRadius: CGFloat = 10
        
        public init() { }
    }
    
    public struct ListTableStyle {
        public var cornerRadius: CGFloat = 10
        public var isOccupyingFullWidth = false
        public var cellBackgroundColor = UIColor.white
        public var cellSelectedBackgroundColor = UIColor(red: 226/255, green: 225/255, blue: 234/255, alpha: 1)
        public var titleLabelFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
        public var chevronImage: UIImage? = UIImage(named: "chevronIcon", in: Bundle.module, compatibleWith: nil)
        
        public init() { }
    }
    
    public struct NavigationLinkStyle {
        public var backgroundColor = UIColor.white
        public var titleLabelFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
        public var selectedBackgroundColor = UIColor(red: 226/255, green: 225/255, blue: 234/255, alpha: 1)
        public var cornerRadius: CGFloat = 10
        public var borderWidth: CGFloat = 0
        public var borderColor = UIColor(red: 226/255, green: 225/255, blue: 234/255, alpha: 1)
        public var chevronImage: UIImage? = UIImage(named: "chevronIcon", in: Bundle.module, compatibleWith: nil)
        
        public init() { }
    }
    
    public struct MainButtonStyle {
        public var width = UIScreen.main.bounds.width - 32
        public var height: CGFloat = 48
        public var backgroundColor = UIColor(red: 1, green: 0, blue: 32/255, alpha: 1)
        public var titleLabelTextColor = UIColor.white
        public var titleLabelFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
        public var cornerRadius: CGFloat = 8
        public var shadowRadius: CGFloat = 2
        public var shadowOpacity: Float = 0.6
        public var shadowOffset = CGSize(width: 1.0, height: 1.0)
        public var shadowColor = UIColor(red: 1, green: 0, blue: 32/255, alpha: 1)

        public init() { }
    }
    
    public struct NegativeButtonStyle {
        public var width = UIScreen.main.bounds.width - 32
        public var height: CGFloat = 48
        public var backgroundColor = UIColor(red: 230/255, green: 231/255, blue: 238/255, alpha: 1)
        public var titleLabelTextColor = UIColor(red: 1, green: 0, blue: 32/255, alpha: 1)
        public var titleLabelFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
        public var cornerRadius: CGFloat = 8
        public var shadowRadius: CGFloat = 2
        public var shadowOpacity: Float = 0.6
        public var shadowOffset = CGSize(width: 1.0, height: 1.0)
        public var shadowColor = UIColor(red: 1, green: 0, blue: 32/255, alpha: 1)
        
        public init() { }
    }
    
    public struct TextFieldStyle {
        public var textColor = UIColor.black
        public var font = UIFont.systemFont(ofSize: 16, weight: .regular)
        public var cornerRadius: CGFloat = 10
        public var backgroundColor = UIColor.white
        public var borderWidth: CGFloat = 1
        public var borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.12)
        public var errorBorderColor = UIColor(red: 230/255, green: 70/255, blue: 70/255, alpha: 1)
        public var errorMessageFont = UIFont.systemFont(ofSize: 13, weight: .regular)

        public init() { }
    }
    
    public struct EmptyStateStyle {
        public var titleTextColor = UIColor.black
        public var titleFont = UIFont.systemFont(ofSize: 22, weight: .semibold)
        public var subtitleTextColor =  UIColor(red: 124/255, green: 136/255, blue: 148/255, alpha: 1)
        public var subtitleFont = UIFont.systemFont(ofSize: 16, weight: .regular)
        public var cornerRadius: CGFloat = 11
        public var iconTintColor = UIColor(red: 93/255, green: 128/255, blue: 254/255, alpha: 1)
        
        public init() { }
    }

    open var insets = Insets()
    open var generalStyle = GeneralStyle()
    open var navigationBarStyle = NavigationBarStyle()
    open var sheetPresentationStyle = SheetPresentationStyle()
    open var sectionStyle = SectionStyle()
    open var gridTableStyle = GridTableStyle()
    open var listTableStyle = ListTableStyle()
    open var navigationLinkStyle = NavigationLinkStyle()
    open var mainButtonStyle = MainButtonStyle()
    open var negativeButtonStyle = NegativeButtonStyle()
    open var textFieldStyle = TextFieldStyle()
    open var emptyStateStyle = EmptyStateStyle()
    
    public init() { }
}
