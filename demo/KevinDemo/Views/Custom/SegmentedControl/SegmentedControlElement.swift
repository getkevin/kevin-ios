//
//  SegmentedControlElement.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 15/02/2022.
//

import SwiftUI

struct SegmentedControlElement<T: Hashable> {
    
    var title: String
    var value: T
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
    
    static func == (lhs: SegmentedControlElement, rhs: SegmentedControlElement) -> Bool {
        lhs.value == rhs.value
    }
}
