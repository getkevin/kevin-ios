//
//  KevinTapableTextDelegate.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 02/06/2022.
//  Copyright © 2022 kevin.. All rights reserved.
//

import Foundation

internal protocol KevinTapableTextDelegate: AnyObject {
    func didTap(_ url: URL)
}
