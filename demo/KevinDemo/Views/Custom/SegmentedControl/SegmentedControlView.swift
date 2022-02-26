//
//  SegmentedControlView.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 04/01/2022.
//

import SwiftUI

struct SegmentedControlView<T: Hashable>: View {
    
    @Binding private var selectedValue: T

    @State private var frames = [T : CGRect]()
    @State private var backgroundFrame = CGRect.zero

    private let elements: [SegmentedControlElement<T>]
    private let indicatorColor: Color

    init(
        selectedValue: Binding<T>,
        elements: [SegmentedControlElement<T>],
        indicatorColor: Color = Color.blue
    ) {
        self._selectedValue = selectedValue
        self.elements = elements
        self.indicatorColor = indicatorColor
        self.frames = elements.reduce(into: [T : CGRect]()) { result, element in
            result[element.value] = .zero
        }
    }

    var body: some View {
        VStack {
            SegmentedControlButtonView(
                selectedValue: $selectedValue,
                frames: $frames,
                backgroundFrame: $backgroundFrame,
                indicatorColor: indicatorColor,
                elements: elements
            )
        }
        .background(
            GeometryReader { geoReader in
                Color.clear.preference(key: RectPreferenceKey.self, value: geoReader.frame(in: .global))
                    .onPreferenceChange(RectPreferenceKey.self) {
                    self.setBackgroundFrame(frame: $0)
                }
            }
        )
    }

    private func setBackgroundFrame(frame: CGRect) {
        backgroundFrame = frame
    }
}
