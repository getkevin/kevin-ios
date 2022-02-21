//
//  TapableText.swift
//  KevinDemo
//
//  Created by Daniel Klinge on 10/02/2022.
//

import SwiftUI
import UIKit

struct TextLabelWithHyperLink: UIViewRepresentable {
    
    @State var linkTintColor: UIColor
    @State var hyperLinkItems: Set<HyperLinkItem>
    private var _attributedString: NSMutableAttributedString
    private var openLink: (HyperLinkItem) -> Void
    private var textColor: UIColor
    private var font: UIFont

    init (
        linkTintColor: UIColor,
        string: String,
        attributes: [NSAttributedString.Key : Any] = [:],
        hyperLinkItems: Set<HyperLinkItem>,
        openLink: @escaping (HyperLinkItem) -> Void,
        textColor: UIColor,
        font: UIFont
    ) {
        self.linkTintColor = linkTintColor
        self.hyperLinkItems = hyperLinkItems
        self._attributedString = NSMutableAttributedString(
            string: string,
            attributes: attributes
        )
        self.openLink = openLink
        self.textColor = textColor
        self.font = font
    }
    
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.isEditable = false
        textView.isSelectable = true
        textView.tintColor = self.linkTintColor
        textView.delegate = context.coordinator
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.textColor = self.textColor
        textView.font = self.font
        textView.textAlignment = .center
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        
        for item in hyperLinkItems {
            let subText = item.subText
            
            _attributedString
                .addAttribute(
                    .link,
                    value: item.url,
                    range: (_attributedString.string as NSString).range(of: subText)
                )
        }
        
        let fittingSize = CGSize(width: uiView.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = uiView.sizeThatFits(fittingSize)
        let topOffset = (uiView.bounds.size.height - size.height * uiView.zoomScale) / 2
        let positiveTopOffset = max(1, topOffset)
        uiView.contentOffset.y = -positiveTopOffset

        uiView.attributedText = _attributedString
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent : TextLabelWithHyperLink
        
        init( parent: TextLabelWithHyperLink ) {
            self.parent = parent
        }
        
        func textView(
            _ textView: UITextView,
            shouldInteractWith URL: URL,
            in characterRange: NSRange,
            interaction: UITextItemInteraction
        ) -> Bool {
            if let ret = parent.hyperLinkItems.first(where: { $0.url == URL.absoluteString }) {
                parent.openLink(ret)
            }
            
            return false
        }
    }
}

struct HyperLinkItem: Hashable {
    
    let subText : String
    let url : String
    let attributes : [NSAttributedString.Key : Any]?
    
    init (
        subText: String,
        url: String,
        attributes: [NSAttributedString.Key : Any]? = nil
    ) {
        self.subText = subText
        self.url = url
        self.attributes = attributes
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(subText)
    }
    
    static func == (lhs: HyperLinkItem, rhs: HyperLinkItem) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
