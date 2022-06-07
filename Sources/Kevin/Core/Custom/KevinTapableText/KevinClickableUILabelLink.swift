//
//  KevinClickableUILabelLink.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 02/06/2022.
//  Copyright © 2022 kevin.. All rights reserved.
//

import Foundation

class KevinClickableUILabelLink {
    var text: String
    var url: URL

    init(
        text: String,
        url: URL
    ) {
        self.text = text
        self.url = url
    }
}
