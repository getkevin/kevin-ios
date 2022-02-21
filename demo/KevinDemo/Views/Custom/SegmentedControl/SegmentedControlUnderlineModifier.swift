//
//  UnderlineModifier.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 08/02/2022.
//

import SwiftUI

/// This modifier provides an animated underscore for the SegmentedControl.
struct SegmentedControlUnderlineModifier<T: Hashable>: ViewModifier {
    var selectedValue: T
    var color: Color
    let frames: [T: CGRect]
    var horizontalOffset: Double = 0.0

    private func getLowerMostMinX(_ frames: [T: CGRect]) -> CGFloat {
        var minX = frames.values.first?.minX ?? 0.0
        
        frames.values.forEach({ frame in
            if frame.minX < minX {
                minX = frame.minX
            }
        })
        
        return minX
    }

    func body(content: Content) -> some View {
        let frameWidth = frames[selectedValue]?.width ?? 0.0
        let frameMinX = frames[selectedValue]?.minX ?? 0.0

        return content
            .background(
                Rectangle()
                    .fill(color)
                    .frame(
                        width: max(frameWidth - horizontalOffset, 0.0),
                        height: 2.0
                    )
                    .offset(
                        x: frameMinX - getLowerMostMinX(frames) + horizontalOffset / 2
                    ),
                alignment: .bottomLeading
            )
            .animation(.default.speed(2))
    }
}
