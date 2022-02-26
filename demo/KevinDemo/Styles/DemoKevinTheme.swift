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
        
        self.generalStyle.primaryTextColor = UIColor(Color("PrimaryTextColor", bundle: nil))
        self.generalStyle.primaryBackgroundColor = UIColor(Color("PrimaryBackgroundColor", bundle: nil))
        
        self.navigationBarStyle.backgroundColorDarkMode = UIColor(Color("AccentColor", bundle: nil))
        self.navigationBarStyle.backgroundColorLightMode = UIColor(Color("AccentColor", bundle: nil))
        
        self.navigationLinkStyle.backgroundColor = UIColor(Color("SelectedOnPrimaryColor", bundle: nil))
        self.navigationLinkStyle.selectedBackgroundColor = UIColor(Color("PrimaryBackgroundColor", bundle: nil))
        
        self.gridTableStyle.cellBackgroundColor = UIColor(Color("SelectedOnPrimaryColor", bundle: nil))
        self.gridTableStyle.cellSelectedBackgroundColor = UIColor(Color("TableCellBackgroundColor", bundle: nil))
        
        self.sheetPresentationStyle.backgroundColor = UIColor(Color("PrimaryBackgroundColor", bundle: nil))
        
        self.listTableStyle.cellSelectedBackgroundColor = UIColor(Color("TableCellBackgroundColor", bundle: nil))
        self.listTableStyle.cellBackgroundColor = UIColor(Color("SelectedOnPrimaryColor", bundle: nil))
        
        self.mainButtonStyle.backgroundColor = UIColor(Color("AccentColor", bundle: nil))
        
        //  for more properties check KevinTheme class
    }
}
