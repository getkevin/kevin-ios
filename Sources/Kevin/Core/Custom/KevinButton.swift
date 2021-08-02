//
//  KevinButton.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import UIKit

internal class KevinButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(highlitedState), for: .touchDown)
        addTarget(self, action: #selector(normalState), for: .touchCancel)
        addTarget(self, action: #selector(normalState), for: .touchUpOutside)
        addTarget(self, action: #selector(normalState), for: .touchUpInside)
        addTarget(self, action: #selector(normalState), for: .touchDragExit)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension KevinButton {
    
    @objc private func highlitedState() {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
            self.alpha = 0.9
            self.titleLabel?.alpha = 0.9
        }
    }
    
    @objc private func normalState() {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform.identity
            self.alpha = 1.0
            self.titleLabel?.alpha = 1.0
        }
    }
}
