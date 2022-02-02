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
        self.selectedOnSecondaryColor = UIColor(Color("SelectedOnSecondaryColor", bundle: nil))
        //  for more properties check KevinTheme class
    }
}
