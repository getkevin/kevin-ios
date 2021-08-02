//
//  KevinCountrySelectionIntent.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

internal class KevinCountrySelectionIntent: IKevinIntent {
    
    public class Initialize: KevinCountrySelectionIntent {
        
        let configuration: KevinCountrySelectionConfiguration
        
        init(configuration: KevinCountrySelectionConfiguration) {
            self.configuration = configuration
        }
    }
}
