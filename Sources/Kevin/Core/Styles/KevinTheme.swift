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
    open var primaryBackgroundColor = UIColor.white
    open var secondaryBackgroundColor = UIColor.white
    
    open var selectedOnPrimaryColor = UIColor(rgb: 0xF0F5FC)
    open var selectedOnSecondaryColor = UIColor(rgb: 0xE8F0FA)
    
    open var errorTextColor = UIColor(rgb: 0xFF0020)
    open var primaryTextColor = UIColor(rgb: 0x0B1E42)
    open var secondaryTextColor = UIColor(rgb: 0x949AA3)
    
    open var navigationBarTitleColor = UIColor.white
    open var navigationBarTintColor = UIColor.white
    open var navigationBarBackgroundColorLight = UIColor(rgb: 0xFF0020)
    open var navigationBarBackgroundColorDark = UIColor(rgb: 0xFF0020)

    open var buttonBackgroundColor = UIColor(rgb: 0xFF0020)
    open var buttonLabelTextColor = UIColor.white
    open var buttonHeight: CGFloat = 50
    open var buttonCornerRadius: CGFloat = 8
    open var buttonShadowRadius: CGFloat = 2
    open var buttonShadowOpacity: Float = 0.6
    open var buttonShadowOffset = CGSize(width: 1.0, height: 1.0)
    open var buttonShadowColor = UIColor(rgb: 0xFF0020)
    open var buttonFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
    open var buttonWidth = UIScreen.main.bounds.width - 32
    
    open var backButtonImage = UIImage(named: "backButtonIcon", in: Bundle.module, compatibleWith: nil)
    open var closeButtonImage = UIImage(named: "closeButtonIcon", in: Bundle.module, compatibleWith: nil)
    open var chevronImage = UIImage(named: "chevronIcon", in: Bundle.module, compatibleWith: nil)
    
    open var countrySelectionBackgroundColor = UIColor(rgb: 0xF0F5FC)
    open var countrySelectionBorderWidth: CGFloat = 0
    
    open var smallFont = UIFont.systemFont(ofSize: 12, weight: .semibold)
    open var mediumFont = UIFont.systemFont(ofSize: 14, weight: .medium)
    open var largeFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
    open var headLineFont = UIFont.systemFont(ofSize: 18, weight: .semibold)
    
    open var leftInset: CGFloat = 16
    open var topInset: CGFloat = 24
    open var rightInset: CGFloat = 16
    open var bottomInset: CGFloat = 25
    
    public init() { }
}
