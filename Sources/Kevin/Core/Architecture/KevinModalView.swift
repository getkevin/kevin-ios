//
//  KevinModalView.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import Foundation
import UIKit

internal protocol KevinModalViewDelegate: AnyObject {
    func onDismiss()
}

internal class KevinModalView<S : IKevinState> : KevinView<S> {
    
    public weak var modalDelegate: KevinModalViewDelegate?

    private let defaultHeight: CGFloat = UIScreen.main.bounds.height * 0.8
    private let dismissibleHeight: CGFloat = UIScreen.main.bounds.height * 0.67
    private let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64
    private var currentContainerHeight: CGFloat = UIScreen.main.bounds.height * 0.8
    
    private var containerViewHeightConstraint: NSLayoutConstraint?
    private var containerViewBottomConstraint: NSLayoutConstraint?
    
    public lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = Kevin.shared.theme.secondaryBackgroundColor
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = maxDimmedAlpha
        return view
    }()
    
    private let maxDimmedAlpha: CGFloat = 0.6
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = 0
        containerView.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        animatePresentContainer()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        animateShowDimmedView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundColor = .clear
        
        addSubview(dimmedView)
        addSubview(containerView)
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            dimmedView.topAnchor.constraint(equalTo: topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: bottomAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: trailingAnchor),

            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        containerViewHeightConstraint = containerView.heightAnchor.constraint(equalToConstant: defaultHeight)
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: defaultHeight)
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseAction))
        dimmedView.addGestureRecognizer(tapGesture)
        
        setupPanGesture()
    }
    
    //MARK: Selectors
    
    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        self.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        let isDraggingDown = translation.y > 0
  
        let newHeight = currentContainerHeight - translation.y
        switch gesture.state {
        case .changed:
            if newHeight < maximumContainerHeight {
                containerViewHeightConstraint?.constant = newHeight
                self.layoutIfNeeded()
            }
        case .ended:
            if newHeight < dismissibleHeight {
                self.animateDismissView()
            }
            else if newHeight < defaultHeight {
                animateContainerHeight(defaultHeight)
            }
            else if newHeight < maximumContainerHeight && isDraggingDown {
                animateContainerHeight(defaultHeight)
            }
            else if newHeight > defaultHeight && !isDraggingDown {
                animateContainerHeight(maximumContainerHeight)
            }
        default:
            break
        }
    }
    
    @objc private func handleCloseAction() {
        animateDismissView()
    }
    
    //MARK: Animations
    
    private func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.35) {
            self.containerViewHeightConstraint?.constant = height
            self.layoutIfNeeded()
        }
        currentContainerHeight = height
    }
    
    private func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }, completion: nil)
    }
    
    public func animateDismissView() {
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.25) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.modalDelegate?.onDismiss()
        }
        UIView.animate(withDuration: 0.2) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            self.layoutIfNeeded()
        }
    }
    
    private func animatePresentContainer() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.containerViewBottomConstraint?.constant = 0
            self.layoutIfNeeded()
        }, completion: nil)
    }
}
