//
//  KevinCancelledError.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 14/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation

public class KevinCancelationError: KevinError {
    convenience init() {
        self.init(description: "User has canceled the flow!")
    }
}
