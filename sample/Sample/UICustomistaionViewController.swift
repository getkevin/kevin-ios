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

        self.navigationBarStyle.backgroundColorDarkMode = UIColor(named: "KevinDarkBlue")!
        self.navigationBarStyle.backgroundColorLightMode = UIColor(named: "KevinDarkBlue")!
        self.navigationBarStyle.titleColor = UIColor(named: "TextWhite")!

        self.navigationLinkStyle.backgroundColor = UIColor(named: "SelectedOnPrimaryColor")!
        self.navigationLinkStyle.selectedBackgroundColor = UIColor(named: "PrimaryBackgroundColor")!

        self.gridTableStyle.cellBackgroundColor = UIColor(named: "SelectedOnPrimaryColor")!
        self.gridTableStyle.cellSelectedBackgroundColor = UIColor(named: "TableCellBackgroundColor")!
        self.gridTableStyle.cellBorderWidth = 1
        self.gridTableStyle.cellBorderColor = UIColor(named: "KevinRed")!
        self.gridTableStyle.cellSelectedBorderWidth = 3
        self.gridTableStyle.cellSelectedBorderColor = UIColor(named: "KevinRed")!

        self.sheetPresentationStyle.backgroundColor = UIColor(named: "PrimaryBackgroundColor")!

        self.listTableStyle.cellBackgroundColor = UIColor(named: "SelectedOnPrimaryColor")!

        self.mainButtonStyle.backgroundColor = UIColor(named: "KevinDarkBlue")!
        self.mainButtonStyle.titleLabelTextColor = UIColor(named: "TextWhite")!
        self.mainButtonStyle.shadowColor = UIColor(named: "KevinDarkBlue")!
        
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
