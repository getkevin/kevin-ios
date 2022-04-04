//
//  KevinAccountLinkingState.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

internal struct KevinAccountLinkingState : IKevinState {
    let bankRedirectUrl: URL
    let accountLinkingType: KevinAccountLinkingType
}
