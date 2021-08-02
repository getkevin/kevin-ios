//
//  KevinBankSelectionIntent.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

internal class KevinBankSelectionIntent: IKevinIntent {
    
    internal class Initialize: KevinBankSelectionIntent {
        
        let configuration: KevinBankSelectionConfiguration
        
        init(configuration: KevinBankSelectionConfiguration) {
            self.configuration = configuration
        }
    }

    internal class OpenCountrySelection: KevinBankSelectionIntent {
        
        let configuration: KevinBankSelectionConfiguration
        
        init(configuration: KevinBankSelectionConfiguration) {
            self.configuration = configuration
        }
    }
}
