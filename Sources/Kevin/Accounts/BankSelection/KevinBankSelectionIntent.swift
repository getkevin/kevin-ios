//
//  KevinBankSelectionIntent.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

internal enum KevinBankSelectionIntent: IKevinIntent {
    case initialize(configuration: KevinBankSelectionConfiguration)
}
