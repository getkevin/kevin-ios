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
        public var primaryBackgroundColor = UIColor(named: "BackgroundPrimary", in: Bundle.current, compatibleWith: nil)!
        public var primaryTextColor = UIColor(named: "TextPrimary", in: Bundle.current, compatibleWith: nil)!
        public var secondaryTextColor = UIColor(named: "TextSecondary", in: Bundle.current, compatibleWith: nil)!
        public var actionTextColor = UIColor(named: "CTABackgroundPrimary", in: Bundle.current, compatibleWith: nil)!
        public var primaryFont = UIFont.systemFont(ofSize: 23, weight: .bold)
        public var secondaryFont = UIFont.systemFont(ofSize: 16, weight: .regular)

        public init() { }
    }
    
    public struct NavigationBarStyle {
        public var titleColor = UIColor(named: "TextPrimary", in: Bundle.current, compatibleWith: nil)!
        public var tintColor = UIColor(named: "KevinRed", in: Bundle.current, compatibleWith: nil)!
        public var backgroundColorLightMode = UIColor(named: "BackgroundPrimary", in: Bundle.current, compatibleWith: nil)!
        public var backgroundColorDarkMode = UIColor(named: "BackgroundPrimary", in: Bundle.current, compatibleWith: nil)!
        public var backButtonImage = UIImage(named: "backButtonIcon", in: Bundle.current, compatibleWith: nil)
        public var closeButtonImage = UIImage(named: "closeButtonIcon", in: Bundle.current, compatibleWith: nil)
        
        public init() { }
    }
    
    public struct SheetPresentationStyle {
        public var dragIndicatorTintColor = UIColor(named: "TextTertiary", in: Bundle.current, compatibleWith: nil)!
        public var backgroundColor = UIColor(named: "BackgroundPrimary", in: Bundle.current, compatibleWith: nil)!
        public var titleLabelFont = UIFont.systemFont(ofSize: 18, weight: .medium)
        public var cornerRadius: CGFloat = 32
        
        public init() { }
    }
    
    public struct SectionStyle {
        public var titleLabelFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
        
        public init() { }
    }
    
    public struct GridTableStyle {
        public var cellBackgroundColor = UIColor(named: "ForegroundPrimary", in: Bundle.current, compatibleWith: nil)!
        public var cellCornerRadius: CGFloat = 8
        public var cellBorderWidth: CGFloat = 0
        public var cellBorderColor = UIColor.clear
        
        public var cellSelectedBackgroundColor = UIColor(named: "ForegroundPrimary", in: Bundle.current, compatibleWith: nil)!
        public var cellSelectedBorderWidth: CGFloat = 2
        public var cellSelectedBorderColor = UIColor(named: "IconBlueToYellow", in: Bundle.current, compatibleWith: nil)!
        
        public init() { }
    }
    
    public struct ListTableStyle {
        public var cornerRadius: CGFloat = 11
        public var isOccupyingFullWidth = false
        public var cellBackgroundColor = UIColor(named: "ForegroundPrimary", in: Bundle.current, compatibleWith: nil)!
        public var cellSelectedBackgroundColor = UIColor(named: "BackgroundSelectedPrimary", in: Bundle.current, compatibleWith: nil)!
        
        public var titleLabelFont = UIFont.systemFont(ofSize: 16, weight: .medium)
        public var chevronImage = UIImage(named: "chevronIcon", in: Bundle.current, compatibleWith: nil)
        
        public init() { }
    }
    
    public struct NavigationLinkStyle {
        public var backgroundColor = UIColor(named: "ForegroundPrimary", in: Bundle.current, compatibleWith: nil)!
        public var titleLabelFont = UIFont.systemFont(ofSize: 16, weight: .medium)
        public var selectedBackgroundColor = UIColor(named: "ForegroundPrimary", in: Bundle.current, compatibleWith: nil)!
        public var cornerRadius: CGFloat = 11
        public var borderWidth: CGFloat = 0
        public var borderColor = UIColor(named: "CTABackgroundPrimary", in: Bundle.current, compatibleWith: nil)!
        public var chevronImage = UIImage(named: "chevronIcon", in: Bundle.current, compatibleWith: nil)
        
        public init() { }
    }
    
    public struct MainButtonStyle {
        public var width = UIScreen.main.bounds.width - 32
        public var height: CGFloat = 48
        public var backgroundColor = UIColor(named: "CTABackgroundPrimary", in: Bundle.current, compatibleWith: nil)!
        public var titleLabelTextColor = UIColor(named: "CTATextPrimary", in: Bundle.current, compatibleWith: nil)!
        public var titleLabelFont = UIFont.systemFont(ofSize: 16, weight: .medium)
        public var cornerRadius: CGFloat = 8
        public var shadowRadius: CGFloat = 0
        public var shadowOpacity: Float = 0
        public var shadowOffset = CGSize.zero
        public var shadowColor = UIColor.clear

        public init() { }
    }
    
    public struct EmptyStateStyle {
        public var titleTextColor = UIColor(named: "TextPrimary", in: Bundle.current, compatibleWith: nil)!
        public var titleFont = UIFont.systemFont(ofSize: 22, weight: .semibold)
        public var subtitleTextColor =  UIColor(named: "TextSecondary", in: Bundle.current, compatibleWith: nil)!
        public var subtitleFont = UIFont.systemFont(ofSize: 16, weight: .regular)
        public var cornerRadius: CGFloat = 11
        public var iconTintColor = UIColor(named: "KevinRed", in: Bundle.current, compatibleWith: nil)!
        
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
    open var emptyStateStyle = EmptyStateStyle()
    
    public init() { }
}
