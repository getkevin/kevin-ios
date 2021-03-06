//
//  KevinBankTransferPromptView.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 14/03/2022.
//  Copyright © 2021 kevin.. All rights reserved.
//

import UIKit

internal class KevinBankTransferPromptView: UIView {
    
    weak var delegate: KevinCardPaymentViewDelegate?
    
    var bankName: String? {
        didSet {
            if let bankName = bankName {
                messageLabel.text = String(format: "window_card_payment_bank_redirect_subtitle".localized(for: Kevin.shared.locale.identifier), bankName)
            } else {
                messageLabel.text = "window_card_payment_redirect_subtitle".localized(for: Kevin.shared.locale.identifier)
            }
        }
    }

    private let dimmedView = UIView()
    private let containerView = UIView()
    private let bankIcon = UIImageView()
    private let headerLabel = UILabel()
    private let messageLabel = UILabel()
    private let negativeButton = KevinButton(type: .custom)
    private let positiveButton = KevinButton(type: .custom)
    
    private var containerViewTopConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initPrompt()
        initButtons()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initPrompt()
        initButtons()
    }
    
    private func initPrompt() {
        self.alpha = 0

        addSubview(dimmedView)
        dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        dimmedView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        dimmedView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        dimmedView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        dimmedView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        dimmedView.addSubview(containerView)
        containerView.backgroundColor = Kevin.shared.theme.sheetPresentationStyle.backgroundColor
        containerView.layer.cornerRadius = Kevin.shared.theme.sheetPresentationStyle.cornerRadius
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.rightAnchor.constraint(equalTo: dimmedView.rightAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: dimmedView.leftAnchor).isActive = true
        containerViewTopConstraint = containerView.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)
        containerViewTopConstraint?.isActive = true

        containerView.addSubview(bankIcon)
        bankIcon.image = UIImage(named: "bank", in: Bundle.module, compatibleWith: nil)
        bankIcon.translatesAutoresizingMaskIntoConstraints = false
        bankIcon.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        bankIcon.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 50).isActive = true
        bankIcon.widthAnchor.constraint(equalToConstant: 44).isActive = true
        bankIcon.heightAnchor.constraint(equalToConstant: 44).isActive = true

        containerView.addSubview(headerLabel)
        headerLabel.text = "window_card_payment_redirect_title".localized(for: Kevin.shared.locale.identifier)
        headerLabel.font = Kevin.shared.theme.generalStyle.primaryFont
        headerLabel.textColor = Kevin.shared.theme.generalStyle.primaryTextColor
        headerLabel.numberOfLines = 0
        headerLabel.textAlignment = .center
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.topAnchor.constraint(equalTo: bankIcon.bottomAnchor, constant: 16).isActive = true
        headerLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16).isActive = true
        headerLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16).isActive = true

        containerView.addSubview(messageLabel)
        messageLabel.text = "window_card_payment_redirect_subtitle".localized(for: Kevin.shared.locale.identifier)
        messageLabel.font = Kevin.shared.theme.generalStyle.secondaryFont
        messageLabel.textColor = Kevin.shared.theme.generalStyle.secondaryTextColor
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 8).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16).isActive = true
    }
        
    private func initButtons() {
        negativeButton.clipsToBounds = false
        negativeButton.layer.cornerRadius = Kevin.shared.theme.mainButtonStyle.cornerRadius
        negativeButton.backgroundColor = Kevin.shared.theme.negativeButtonStyle.backgroundColor
        negativeButton.titleLabel?.font = Kevin.shared.theme.mainButtonStyle.titleLabelFont
        negativeButton.setTitleColor(Kevin.shared.theme.negativeButtonStyle.titleLabelTextColor, for: .normal)
        negativeButton.setTitle("no".localized(for: Kevin.shared.locale.identifier), for: .normal)
        containerView.addSubview(negativeButton)

        negativeButton.translatesAutoresizingMaskIntoConstraints = false
        negativeButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Kevin.shared.theme.insets.bottom).isActive = true
        negativeButton.heightAnchor.constraint(equalToConstant: Kevin.shared.theme.mainButtonStyle.height).isActive = true
        negativeButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 32).isActive = true
        negativeButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 16).isActive = true

        negativeButton.addTarget(self, action: #selector(self.onNoButtonClicked(_:)), for: .touchUpInside)

        positiveButton.clipsToBounds = false
        positiveButton.layer.cornerRadius = Kevin.shared.theme.mainButtonStyle.cornerRadius
        positiveButton.backgroundColor = Kevin.shared.theme.mainButtonStyle.backgroundColor
        positiveButton.titleLabel?.font = Kevin.shared.theme.mainButtonStyle.titleLabelFont
        positiveButton.setTitleColor(Kevin.shared.theme.mainButtonStyle.titleLabelTextColor, for: .normal)
        positiveButton.setTitle("yes".localized(for: Kevin.shared.locale.identifier), for: .normal)
        containerView.addSubview(positiveButton)

        positiveButton.translatesAutoresizingMaskIntoConstraints = false
        positiveButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Kevin.shared.theme.insets.bottom).isActive = true
        positiveButton.widthAnchor.constraint(equalTo: negativeButton.widthAnchor).isActive = true
        positiveButton.heightAnchor.constraint(equalToConstant: Kevin.shared.theme.mainButtonStyle.height).isActive = true
        positiveButton.leftAnchor.constraint(equalTo: negativeButton.rightAnchor, constant: 12).isActive = true
        positiveButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -16).isActive = true

        positiveButton.addTarget(self, action: #selector(self.onYesButtonClicked(_:)), for: .touchUpInside)
    }
    
    @objc private func onNoButtonClicked(_ sender: UIButton) {
        delegate?.onUserRedirectAction(shouldRedirect: false)
    }

    @objc private func onYesButtonClicked(_ sender: UIButton) {
        delegate?.onUserRedirectAction(shouldRedirect: true)
    }
    
    func animatePresentContainer() {
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                self.containerViewTopConstraint?.constant = -self.containerView.frame.height
                self.layoutIfNeeded()
            }
        }
    }
    
    func animateHideContainer(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.3) {
            self.containerViewTopConstraint?.constant = 0
            self.layoutIfNeeded()
        } completion: { _ in
            UIView.animate(withDuration: 0.25) {
                self.alpha = 0
            } completion: { _ in
                guard let completion = completion else {
                    return
                }
                completion()
            }
        }
    }
}
