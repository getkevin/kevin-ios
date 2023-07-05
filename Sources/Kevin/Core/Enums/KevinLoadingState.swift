//
//  KevinLoadingState.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 11/03/2022.
//  Copyright © 2022 kevin.. All rights reserved.
//

import Foundation

enum KevinLoadingState: Equatable {
    case notLoading
    case loading
    case success
    case failure(message: String?)
}
