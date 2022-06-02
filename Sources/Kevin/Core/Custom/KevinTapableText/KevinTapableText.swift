//
//  KevinTapableText.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 31/05/2022.
//  Copyright © 2022 kevin.. All rights reserved.
//

import Foundation
import UIKit

final class KevinTapableText: UILabel {

    // MARK: Public properties
    
    weak var delegate: KevinTapableTextDelegate?
    
    var tapableLinks: [KevinTapableTextLink] = [] {
        didSet { updateTextStorage() }
    }

    var tapableColor: UIColor = Kevin.shared.theme.generalStyle.actionTextColor {
        didSet { updateTextStorage() }
    }
   
    // MARK: Overriden properties

    override var text: String? {
        didSet { updateTextStorage() }
    }

    override var attributedText: NSAttributedString? {
        didSet { updateTextStorage() }
    }

    override var font: UIFont! {
        didSet { updateTextStorage() }
    }

    override var textColor: UIColor! {
        didSet { updateTextStorage() }
    }

    override var textAlignment: NSTextAlignment {
        didSet { updateTextStorage()}
    }

    override var numberOfLines: Int {
        didSet { textContainer.maximumNumberOfLines = numberOfLines }
    }

    override var intrinsicContentSize: CGSize {
        guard let text = text, !text.isEmpty else {
            return .zero
        }

        textContainer.size = CGSize(width: self.preferredMaxLayoutWidth, height: CGFloat.greatestFiniteMagnitude)
        let size = layoutManager.usedRect(for: textContainer)
        return CGSize(width: ceil(size.width), height: ceil(size.height))
    }

    // MARK: Private properties

    private let layoutManager = NSLayoutManager()
    private let textContainer = NSTextContainer(size: CGSize.zero)
    private var textStorage = NSTextStorage()
    private var lockUpdating = true
    private var heightCorrection: CGFloat = 0
    private var activeElements = [ElementTuple]()

    typealias ElementTuple = (range: NSRange, element: KevinTapableTextLink)

    override public init(frame: CGRect) {
        super.init(frame: frame)
        lockUpdating = false
        setupLabel()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        lockUpdating = false
        setupLabel()
    }
    
    override func drawText(in rect: CGRect) {
        let range = NSRange(location: 0, length: textStorage.length)
        
        textContainer.size = rect.size
        let usedRect = layoutManager.usedRect(for: textContainer)
        heightCorrection = (rect.height - usedRect.height)/2
        let glyphOriginY = heightCorrection > 0 ? rect.origin.y + heightCorrection : rect.origin.y
        let newOrigin = CGPoint(x: rect.origin.x, y: glyphOriginY)
        
        layoutManager.drawBackground(forGlyphRange: range, at: newOrigin)
        layoutManager.drawGlyphs(forGlyphRange: range, at: newOrigin)
    }

    // MARK: Label setup

    private func setupLabel() {
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = lineBreakMode
        textContainer.maximumNumberOfLines = numberOfLines
        isUserInteractionEnabled = true
    }
    
    private func updateTextStorage() {
        if lockUpdating { return }

        activeElements.removeAll()
        guard let attributedText = attributedText, attributedText.length > 0 else {
            textStorage.setAttributedString(NSAttributedString())
            setNeedsDisplay()
            return
        }

        let mutableAttributedString = NSMutableAttributedString(attributedString: attributedText)
        setupParagraphStyle(mutableAttributedString)
        setupTapableLinks(for: mutableAttributedString)
        textStorage.setAttributedString(mutableAttributedString)
        lockUpdating = true
        text = mutableAttributedString.string
        lockUpdating = false
        setNeedsDisplay()
    }
    
    private func setupParagraphStyle(_ mutableAttributedString: NSMutableAttributedString) {
        var range = NSRange(location: 0, length: 0)
        var attributes = mutableAttributedString.attributes(at: 0, effectiveRange: &range)

        let paragraphStyle = attributes[NSAttributedString.Key.paragraphStyle] as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineSpacing = 0
        paragraphStyle.minimumLineHeight = 0
        attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        mutableAttributedString.setAttributes(attributes, range: range)
    }

    private func setupTapableLinks(for mutableAttributedString: NSMutableAttributedString) {
        tapableLinks.forEach({ tapableLink in
            if let range = mutableAttributedString.range(of: tapableLink.text) {
                activeElements.append((range: range, element: tapableLink))
            }
        })
        
        var range = NSRange(location: 0, length: 0)
        var attributes = mutableAttributedString.attributes(at: 0, effectiveRange: &range)
        
        attributes[NSAttributedString.Key.font] = font!
        attributes[NSAttributedString.Key.foregroundColor] = textColor
        mutableAttributedString.addAttributes(attributes, range: range)
                
        for (range, _) in activeElements {
            attributes[NSAttributedString.Key.foregroundColor] = tapableColor
            mutableAttributedString.setAttributes(attributes, range: range)
        }
    }
    
    // MARK: Touche handlers
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if onTouch(touch) { return }
        super.touchesEnded(touches, with: event)
    }

    func onTouch(_ touch: UITouch) -> Bool {
        let location = touch.location(in: self)
        var avoidSuperCall = false
        
        switch touch.phase {
        case .ended, .regionExited:
            guard let element = getElement(at: location) else { return avoidSuperCall }
            
            delegate?.didTap(element.url)
            
            avoidSuperCall = true
        case .stationary:
            break
        default:
            break
        }
        
        return avoidSuperCall
    }
    
    private func getElement(at location: CGPoint) -> KevinTapableTextLink? {
        guard textStorage.length > 0 else {
            return nil
        }
        
        var correctLocation = location
        correctLocation.y -= heightCorrection
        let boundingRect = layoutManager.boundingRect(forGlyphRange: NSRange(location: 0, length: textStorage.length), in: textContainer)
        guard boundingRect.contains(correctLocation) else {
            return nil
        }
        
        let index = layoutManager.glyphIndex(for: correctLocation, in: textContainer)
        
        for (range, element) in activeElements {
            if index >= range.location && index <= range.location + range.length {
                return element
            }
        }
        
        return nil
    }
}
