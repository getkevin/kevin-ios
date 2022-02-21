//
//  SegmentedControlButtonView.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 15/02/2022.
//

import SwiftUI

struct SegmentedControlButtonView<T: Hashable>: View {
    @Binding internal var selectedValue: T
    @Binding internal var frames: [T : CGRect]
    @Binding internal var backgroundFrame: CGRect

    internal let elements: [SegmentedControlElement<T>]
    internal let indicatorColor: Color

    init(
        selectedValue: Binding<T>,
        frames: Binding<[T : CGRect]>,
        backgroundFrame: Binding<CGRect>,
        indicatorColor: Color,
        elements: [SegmentedControlElement<T>]
    ) {
        _selectedValue = selectedValue
        _frames = frames
        _backgroundFrame = backgroundFrame

        self.elements = elements
        self.indicatorColor = indicatorColor
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(elements, id: \.value) { element in
                Button(action:{ selectedValue = element.value })
                {
                    HStack {
                        Text(element.title)
                            .style(
                                selectedValue == element.value ?
                                    .segmentedPickerSelected :
                                    .segmentedPickerUnselected
                            )
                    }
                }
                .buttonStyle(CustomSegmentButtonStyle())
                .frame(minWidth: 100, maxWidth: .infinity, minHeight: 24)
                .background(
                    GeometryReader { geoReader in
                        Color.clear.preference(
                            key: RectPreferenceKey.self,
                            value: geoReader.frame(in: .global)
                        )
                        .onPreferenceChange(RectPreferenceKey.self) {
                            self.frames[element.value] = $0
                        }
                    }
                )
            }
        }
        .modifier(
            SegmentedControlUnderlineModifier(
                selectedValue: selectedValue,
                color: indicatorColor,
                frames: frames,
                horizontalOffset: 32.0
            )
        )
    }
}

private struct CustomSegmentButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .padding(EdgeInsets(top: 14, leading: 20, bottom: 20, trailing: 20))
            .background(Color.clear)
    }
}
