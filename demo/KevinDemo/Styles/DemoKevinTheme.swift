//
//  DemoKevinTheme.swift
//  KevinDemo
//
//  Created by Edgar Žigis on 2021-12-11.
//

import Foundation
import SwiftUI
import Kevin

public class DemoKevinTheme : KevinTheme {
    
    public override init() {
        super.init()
        self.primaryTextColor = UIColor(Color("PrimaryTextColor", bundle: nil))
        self.primaryBackgroundColor = UIColor(Color("PrimaryBackgroundColor", bundle: nil))
        self.secondaryBackgroundColor = UIColor(Color("SecondaryBackgroundColor", bundle: nil))
        self.selectedOnPrimaryColor = UIColor(Color("SelectedOnPrimaryColor", bundle: nil))
        self.selectedOnSecondaryColor = UIColor(Color("SelectedOnSecondaryColor", bundle: nil))
        self.highlightTextColor = UIColor(Color("PrimaryTextColor", bundle: nil))
        self.highlightBackgroundColor = UIColor(Color("SelectedOnPrimaryColor", bundle: nil))

        self.navigationBarBackgroundColorLight = UIColor(Color("AccentColor", bundle: nil))
        self.navigationBarBackgroundColorDark = UIColor(Color("AccentColor", bundle: nil))
        self.buttonBackgroundColor = UIColor(Color("AccentColor", bundle: nil))
        self.buttonShadowColor = UIColor(Color("AccentColor", bundle: nil))
        //  for more properties check KevinTheme class
    }
}
