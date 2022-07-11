//
//  HalfASheetConfiguration.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 16/06/2022.
//

import SwiftUI
import HalfASheet

extension HalfASheetConfiguration {
    static var defaultMinimal: Self {
        return make(height: .minimal)
    }
    
    static var defaultProportional: Self {
        return make(height: .proportional(0.85))
    }
    
    private static func make(height: HalfASheetHeight) -> Self {
        return HalfASheetConfiguration(
            appearanceAnimationDuration: 0.2,
            backgroundColor: Color("PrimaryBackgroundColor"),
            height: .minimal,
            contentInsets: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16),
            allowsDraggingToDismiss: true
        )
    }
}
