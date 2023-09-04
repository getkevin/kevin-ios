//
//  UICustomistaionViewController.swift
//  Sample
//
//  Created by Kacper Dziubek on 22/05/2023.
//

import Foundation
import SwiftUI
import Kevin

public class DemoKevinTheme : KevinTheme {

    public override init() {
        super.init()

        self.generalStyle.primaryTextColor = UIColor(named: "PrimaryTextColor")!
        self.generalStyle.primaryBackgroundColor = UIColor(named: "PrimaryBackgroundColor")!

        self.navigationBarStyle.backgroundColorDarkMode = UIColor(named: "AccentColor")!
        self.navigationBarStyle.backgroundColorLightMode = UIColor(named: "AccentColor")!

        self.navigationLinkStyle.backgroundColor = UIColor(named: "SelectedOnPrimaryColor")!
        self.navigationLinkStyle.selectedBackgroundColor = UIColor(named: "PrimaryBackgroundColor")!

        self.gridTableStyle.cellBackgroundColor = UIColor(named: "SelectedOnPrimaryColor")!
        self.gridTableStyle.cellSelectedBackgroundColor = UIColor(named: "TableCellBackgroundColor")!
        self.gridTableStyle.cellBorderWidth = 1
        self.gridTableStyle.cellBorderColor = UIColor(named: "AccentColor")!
        self.gridTableStyle.cellSelectedBorderWidth = 3
        self.gridTableStyle.cellSelectedBorderColor = UIColor(named: "AccentColor")!
        
        self.sheetPresentationStyle.backgroundColor = UIColor(named: "PrimaryBackgroundColor")!

        self.listTableStyle.cellSelectedBackgroundColor = UIColor(Color("TableCellBackgroundColor", bundle: nil))
        self.listTableStyle.cellBackgroundColor = UIColor(named: "SelectedOnPrimaryColor")!

        self.mainButtonStyle.backgroundColor = UIColor(named: "AccentColor")!

        self.emptyStateStyle.titleTextColor = UIColor(named: "PrimaryTextColor")!
        self.emptyStateStyle.subtitleTextColor = UIColor(named: "SecondaryTextColor")!
        self.emptyStateStyle.iconTintColor = UIColor(named: "PrimaryTextColor")!

        //  for more properties check KevinTheme class
    }
}

class UICustomisedAccountLinkingController: AccountLinkingViewController {

    override func viewDidLoad() {
        /**
         * Set global kevin. theme to your custom one.
         */
        Kevin.shared.theme = DemoKevinTheme()

        super.viewDidLoad()
    }
}
