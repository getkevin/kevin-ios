//
//  KevinCardPaymentView.swift
//  kevin.iOS
//
//  Created by Daniel Klinge on 02/03/2022.
//  Copyright © 2021 kevin.. All rights reserved.
//

import UIKit
import WebKit

internal class KevinCardPaymentView: KevinView<KevinCardPaymentState> {
    
    weak var delegate: KevinCardPaymentViewDelegate?
    
    private var previousStateUrl: URL?
    private var previousCardDetailsVisibility: Bool = true
    private var previousLoadingVisibility: Bool = false

    private let handlerName = "iOSHandler"

    private let scrollView = UIScrollView()
    private let cardFormContainerView = UIView()
    private let cardIconView = UIImageView()
    private let amountLabel = UILabel()
    private let paymentTypeLabel = UILabel()
    private let cardNumberLabel = UILabel()
    private let cardNumberTextField = KevinErrorTextField()
    private let cardholderNameLabel = UILabel()
    private let cardholderNameTextField = KevinErrorTextField()
    private let expiryDateContainer = UIView()
    private let expiryDateLabel = UILabel()
    private let expiryDateTextField = KevinErrorTextField()
    private let cvvContainer = UIView()
    private let cvvLabel = UILabel()
    private let cvvLabelHint = UIImageView()
    private let cvvLabelHintTapView = UIView()
    private let cvvTextField = KevinErrorTextField()
    private let paymentNoticeIcon = UIImageView()
    private let paymentNoticeLabel = UILabel()
    private let continueButton = KevinButton(type: .custom)
    
    private let loaderView = KevinLoaderView()
    private let bankTransferPrompt = KevinBankTransferPromptView()

    private var webView: WKWebView?
    
    override func render(state: KevinCardPaymentState) {
        if let url = state.url, url != previousStateUrl {
            previousStateUrl = url
            webView?.load(URLRequest(url: url))
        }
        continueButton.isEnabled = state.isContinueEnabled
        amountLabel.text = state.amount ?? ""
        showCardDetails(state.showCardDetails)
        showLoading(state.loadingState == KevinLoadingState.loading)
    }

    override func viewDidLoad() {
        backgroundColor = Kevin.shared.theme.generalStyle.primaryBackgroundColor
        
        let tapGestureBackground = UITapGestureRecognizer(target: self, action: #selector(self.onBackgroundTapped(_:)))
        self.addGestureRecognizer(tapGestureBackground)
        
        initObservers()
        initWebView()
        initCardForm()
        initAmountContainer()
        initCardNumberInput()
        initCardholderNameInput()
        initExpiryDateAndCvvContainers()
        initPaymentNoticeLabel()
        initContinueButton()
        initLoader()
        initBankTransferPrompt()
    }
    
    private func initObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func initWebView() {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.add(self, name: handlerName)

        webView = WKWebView(frame: self.frame, configuration: configuration)
        if let webView = webView {
            addSubview(webView)
            webView.translatesAutoresizingMaskIntoConstraints = false
            webView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            webView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
            webView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            webView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            webView.navigationDelegate = self
        }
    }
    
    private func initCardForm() {
        scrollView.backgroundColor = Kevin.shared.theme.generalStyle.primaryBackgroundColor
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        cardFormContainerView.backgroundColor = Kevin.shared.theme.generalStyle.primaryBackgroundColor
        scrollView.addSubview(cardFormContainerView)
        cardFormContainerView.translatesAutoresizingMaskIntoConstraints = false
        cardFormContainerView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        cardFormContainerView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        cardFormContainerView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        cardFormContainerView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        cardFormContainerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }
    
    private func initAmountContainer() {
        cardFormContainerView.addSubview(cardIconView)
        cardIconView.image = UIImage(named: "card", in: Bundle.module, compatibleWith: nil)
        cardIconView.translatesAutoresizingMaskIntoConstraints = false
        cardIconView.centerXAnchor.constraint(equalTo: cardFormContainerView.centerXAnchor).isActive = true
        cardIconView.topAnchor.constraint(equalTo: cardFormContainerView.topAnchor, constant: 24).isActive = true
        cardIconView.widthAnchor.constraint(equalToConstant: 56).isActive = true
        cardIconView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        cardFormContainerView.addSubview(amountLabel)
        amountLabel.text = ""
        amountLabel.font = Kevin.shared.theme.generalStyle.primaryFont
        amountLabel.textColor = Kevin.shared.theme.generalStyle.primaryTextColor
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.centerXAnchor.constraint(equalTo: cardFormContainerView.centerXAnchor).isActive = true
        amountLabel.topAnchor.constraint(equalTo: cardIconView.bottomAnchor, constant: 16).isActive = true

        cardFormContainerView.addSubview(paymentTypeLabel)
        paymentTypeLabel.text = "window_card_payment_label".localized(for: Kevin.shared.locale.identifier)
        paymentTypeLabel.font = Kevin.shared.theme.generalStyle.secondaryFont
        paymentTypeLabel.textColor = Kevin.shared.theme.generalStyle.secondaryTextColor
        paymentTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        paymentTypeLabel.centerXAnchor.constraint(equalTo: cardFormContainerView.centerXAnchor).isActive = true
        paymentTypeLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 8).isActive = true
    }
        
    private func initCardNumberInput() {
        cardFormContainerView.addSubview(cardNumberLabel)
        cardNumberLabel.text = "window_card_payment_card_number_label".localized(for: Kevin.shared.locale.identifier)
        cardNumberLabel.font = Kevin.shared.theme.generalStyle.secondaryFont
        cardNumberLabel.textColor = Kevin.shared.theme.generalStyle.secondaryTextColor
        cardNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        cardNumberLabel.leftAnchor.constraint(equalTo: cardFormContainerView.leftAnchor, constant: 16).isActive = true
        cardNumberLabel.rightAnchor.constraint(equalTo: cardFormContainerView.rightAnchor, constant: 16).isActive = true
        cardNumberLabel.topAnchor.constraint(equalTo: paymentTypeLabel.bottomAnchor, constant: 38).isActive = true
        
        cardFormContainerView.addSubview(cardNumberTextField)
        cardNumberTextField.textField.textInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        cardNumberTextField.textField.placeholder = "window_card_payment_card_number_hint".localized(for: Kevin.shared.locale.identifier)
        cardNumberTextField.textField.placeholderColor = Kevin.shared.theme.generalStyle.secondaryTextColor
        cardNumberTextField.textField.font = Kevin.shared.theme.textFieldStyle.font
        cardNumberTextField.textField.textColor = Kevin.shared.theme.textFieldStyle.textColor
        cardNumberTextField.textField.backgroundColor = Kevin.shared.theme.textFieldStyle.backgroundColor
        cardNumberTextField.textField.layer.cornerRadius = Kevin.shared.theme.textFieldStyle.cornerRadius
        cardNumberTextField.textField.layer.borderColor = Kevin.shared.theme.textFieldStyle.borderColor.cgColor
        cardNumberTextField.textField.layer.borderWidth = Kevin.shared.theme.textFieldStyle.borderWidth
        cardNumberTextField.textField.autocorrectionType = .no
        cardNumberTextField.textField.keyboardType = .numberPad
        cardNumberTextField.textField.clearButtonMode = .whileEditing
        cardNumberTextField.textField.delegate = self
        cardNumberTextField.textField.addTarget(self, action: #selector(onTextFieldEdited(_:)), for: .editingChanged)
        cardNumberTextField.errorLabel.font = Kevin.shared.theme.textFieldStyle.errorMessageFont
        cardNumberTextField.borderColor = Kevin.shared.theme.textFieldStyle.errorBorderColor
        cardNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        cardNumberTextField.leftAnchor.constraint(equalTo: cardFormContainerView.leftAnchor, constant: 16).isActive = true
        cardNumberTextField.rightAnchor.constraint(equalTo: cardFormContainerView.rightAnchor, constant: -16).isActive = true
        cardNumberTextField.topAnchor.constraint(equalTo: cardNumberLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func initCardholderNameInput() {
        cardFormContainerView.addSubview(cardholderNameLabel)
        cardholderNameLabel.text = "window_card_payment_cardholder_name_label".localized(for: Kevin.shared.locale.identifier)
        cardholderNameLabel.font = Kevin.shared.theme.generalStyle.secondaryFont
        cardholderNameLabel.textColor = Kevin.shared.theme.generalStyle.secondaryTextColor
        cardholderNameLabel.translatesAutoresizingMaskIntoConstraints = false
        cardholderNameLabel.leftAnchor.constraint(equalTo: cardFormContainerView.leftAnchor, constant: 16).isActive = true
        cardholderNameLabel.rightAnchor.constraint(equalTo: cardFormContainerView.rightAnchor, constant: 16).isActive = true
        cardholderNameLabel.topAnchor.constraint(equalTo: cardNumberTextField.bottomAnchor, constant: 27).isActive = true

        cardFormContainerView.addSubview(cardholderNameTextField)
        cardholderNameTextField.textField.textInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        cardholderNameTextField.textField.placeholder = "window_card_payment_cardholder_name_hint".localized(for: Kevin.shared.locale.identifier)
        cardholderNameTextField.textField.placeholderColor = Kevin.shared.theme.generalStyle.secondaryTextColor
        cardholderNameTextField.textField.font = Kevin.shared.theme.textFieldStyle.font
        cardholderNameTextField.textField.textColor = Kevin.shared.theme.textFieldStyle.textColor
        cardholderNameTextField.textField.backgroundColor = Kevin.shared.theme.textFieldStyle.backgroundColor
        cardholderNameTextField.textField.layer.cornerRadius = Kevin.shared.theme.textFieldStyle.cornerRadius
        cardholderNameTextField.textField.layer.borderColor = Kevin.shared.theme.textFieldStyle.borderColor.cgColor
        cardholderNameTextField.textField.layer.borderWidth = Kevin.shared.theme.textFieldStyle.borderWidth
        cardholderNameTextField.textField.autocorrectionType = .no
        cardholderNameTextField.textField.autocapitalizationType = .words
        cardholderNameTextField.textField.clearButtonMode = .whileEditing
        cardholderNameTextField.textField.delegate = self
        cardholderNameTextField.textField.addTarget(self, action: #selector(onTextFieldEdited(_:)), for: .editingChanged)
        cardholderNameTextField.errorLabel.font = Kevin.shared.theme.textFieldStyle.errorMessageFont
        cardholderNameTextField.borderColor = Kevin.shared.theme.textFieldStyle.errorBorderColor
        cardholderNameTextField.translatesAutoresizingMaskIntoConstraints = false
        cardholderNameTextField.leftAnchor.constraint(equalTo: cardFormContainerView.leftAnchor, constant: 16).isActive = true
        cardholderNameTextField.rightAnchor.constraint(equalTo: cardFormContainerView.rightAnchor, constant: -16).isActive = true
        cardholderNameTextField.topAnchor.constraint(equalTo: cardholderNameLabel.bottomAnchor, constant: 8).isActive = true
    }

    private func initExpiryDateAndCvvContainers() {
        cardFormContainerView.addSubview(expiryDateContainer)
        expiryDateContainer.backgroundColor = .clear
        expiryDateContainer.translatesAutoresizingMaskIntoConstraints = false
        expiryDateContainer.leftAnchor.constraint(equalTo: cardFormContainerView.leftAnchor, constant: 16).isActive = true
        expiryDateContainer.topAnchor.constraint(equalTo: cardholderNameTextField.bottomAnchor, constant: 27).isActive = true
        initExpiryDateInput()
        
        cardFormContainerView.addSubview(cvvContainer)
        cvvContainer.backgroundColor = .clear
        cvvContainer.translatesAutoresizingMaskIntoConstraints = false
        cvvContainer.leftAnchor.constraint(equalTo: expiryDateContainer.rightAnchor, constant: 32).isActive = true
        cvvContainer.rightAnchor.constraint(equalTo: cardFormContainerView.rightAnchor, constant: -16).isActive = true
        cvvContainer.topAnchor.constraint(equalTo: expiryDateContainer.topAnchor).isActive = true
        cvvContainer.widthAnchor.constraint(equalTo: expiryDateContainer.widthAnchor).isActive = true
        initCvvInput()
    }
    
    private func initExpiryDateInput() {
        expiryDateContainer.addSubview(expiryDateLabel)
        expiryDateLabel.text = "window_card_payment_expiry_date_label".localized(for: Kevin.shared.locale.identifier)
        expiryDateLabel.font = Kevin.shared.theme.generalStyle.secondaryFont
        expiryDateLabel.textColor = Kevin.shared.theme.generalStyle.secondaryTextColor
        expiryDateLabel.translatesAutoresizingMaskIntoConstraints = false
        expiryDateLabel.leftAnchor.constraint(equalTo: expiryDateContainer.leftAnchor).isActive = true
        expiryDateLabel.rightAnchor.constraint(equalTo: expiryDateContainer.rightAnchor).isActive = true
        expiryDateLabel.topAnchor.constraint(equalTo: expiryDateContainer.topAnchor).isActive = true
        
        expiryDateContainer.addSubview(expiryDateTextField)
        expiryDateTextField.textField.textInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        expiryDateTextField.textField.placeholder = "window_card_payment_expiry_date_hint".localized(for: Kevin.shared.locale.identifier)
        expiryDateTextField.textField.placeholderColor = Kevin.shared.theme.generalStyle.secondaryTextColor
        expiryDateTextField.textField.font = Kevin.shared.theme.textFieldStyle.font
        expiryDateTextField.textField.textColor = Kevin.shared.theme.textFieldStyle.textColor
        expiryDateTextField.textField.backgroundColor = Kevin.shared.theme.textFieldStyle.backgroundColor
        expiryDateTextField.textField.layer.cornerRadius = Kevin.shared.theme.textFieldStyle.cornerRadius
        expiryDateTextField.textField.layer.borderColor = Kevin.shared.theme.textFieldStyle.borderColor.cgColor
        expiryDateTextField.textField.layer.borderWidth = Kevin.shared.theme.textFieldStyle.borderWidth
        expiryDateTextField.textField.autocorrectionType = .no
        expiryDateTextField.textField.keyboardType = .numberPad
        expiryDateTextField.textField.clearButtonMode = .whileEditing
        expiryDateTextField.textField.delegate = self
        expiryDateTextField.textField.addTarget(self, action: #selector(onTextFieldEdited(_:)), for: .editingChanged)
        expiryDateTextField.errorLabel.font = Kevin.shared.theme.textFieldStyle.errorMessageFont
        expiryDateTextField.borderColor = Kevin.shared.theme.textFieldStyle.errorBorderColor
        expiryDateTextField.translatesAutoresizingMaskIntoConstraints = false
        expiryDateTextField.leftAnchor.constraint(equalTo: expiryDateContainer.leftAnchor).isActive = true
        expiryDateTextField.rightAnchor.constraint(equalTo: expiryDateContainer.rightAnchor).isActive = true
        expiryDateTextField.topAnchor.constraint(equalTo: expiryDateLabel.bottomAnchor, constant: 8).isActive = true
        expiryDateTextField.bottomAnchor.constraint(equalTo: expiryDateContainer.bottomAnchor).isActive = true
    }

    private func initCvvInput() {
        cvvContainer.addSubview(cvvLabel)
        cvvLabel.text = "window_card_payment_cvv_label".localized(for: Kevin.shared.locale.identifier)
        cvvLabel.font = Kevin.shared.theme.generalStyle.secondaryFont
        cvvLabel.textColor = Kevin.shared.theme.generalStyle.secondaryTextColor
        cvvLabel.translatesAutoresizingMaskIntoConstraints = false
        cvvLabel.leftAnchor.constraint(equalTo: cvvContainer.leftAnchor).isActive = true
        cvvLabel.topAnchor.constraint(equalTo: cvvContainer.topAnchor).isActive = true
        cvvLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        cvvContainer.addSubview(cvvLabelHint)
        cvvLabelHint.image = UIImage(named: "questionMark", in: Bundle.module, compatibleWith: nil)
        cvvLabelHint.translatesAutoresizingMaskIntoConstraints = false
        cvvLabelHint.leftAnchor.constraint(equalTo: cvvLabel.rightAnchor, constant: 4).isActive = true
        cvvLabelHint.rightAnchor.constraint(lessThanOrEqualTo: cvvContainer.rightAnchor).isActive = true
        cvvLabelHint.bottomAnchor.constraint(equalTo: cvvLabel.bottomAnchor).isActive = true
        cvvLabelHint.widthAnchor.constraint(equalToConstant: 16).isActive = true
        cvvLabelHint.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        cvvLabelHintTapView.backgroundColor = .clear
        cvvContainer.addSubview(cvvLabelHintTapView)
        cvvLabelHintTapView.translatesAutoresizingMaskIntoConstraints = false
        cvvLabelHintTapView.leftAnchor.constraint(equalTo: cvvLabelHint.leftAnchor, constant: -8).isActive = true
        cvvLabelHintTapView.rightAnchor.constraint(lessThanOrEqualTo: cvvLabelHint.rightAnchor, constant: 8).isActive = true
        cvvLabelHintTapView.bottomAnchor.constraint(equalTo: cvvLabelHint.bottomAnchor, constant: 8).isActive = true
        cvvLabelHintTapView.topAnchor.constraint(equalTo: cvvLabelHint.topAnchor, constant: -8).isActive = true

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.onCvvHintTapped(_:)))
        cvvLabelHintTapView.isUserInteractionEnabled = true
        cvvLabelHintTapView.addGestureRecognizer(tapRecognizer)

        cvvContainer.addSubview(cvvTextField)
        cvvTextField.textField.textInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        cvvTextField.textField.placeholder = "window_card_payment_cvv_hint".localized(for: Kevin.shared.locale.identifier)
        cvvTextField.textField.placeholderColor = Kevin.shared.theme.generalStyle.secondaryTextColor
        cvvTextField.textField.font = Kevin.shared.theme.textFieldStyle.font
        cvvTextField.textField.textColor = Kevin.shared.theme.textFieldStyle.textColor
        cvvTextField.textField.backgroundColor = Kevin.shared.theme.textFieldStyle.backgroundColor
        cvvTextField.textField.layer.cornerRadius = Kevin.shared.theme.textFieldStyle.cornerRadius
        cvvTextField.textField.layer.borderColor = Kevin.shared.theme.textFieldStyle.borderColor.cgColor
        cvvTextField.textField.layer.borderWidth = Kevin.shared.theme.textFieldStyle.borderWidth
        cvvTextField.textField.autocorrectionType = .no
        cvvTextField.textField.keyboardType = .numberPad
        cvvTextField.textField.clearButtonMode = .whileEditing
        cvvTextField.textField.delegate = self
        cvvTextField.textField.addTarget(self, action: #selector(onTextFieldEdited(_:)), for: .editingChanged)
        cvvTextField.errorLabel.font = Kevin.shared.theme.textFieldStyle.errorMessageFont
        cvvTextField.borderColor = Kevin.shared.theme.textFieldStyle.errorBorderColor
        cvvTextField.translatesAutoresizingMaskIntoConstraints = false
        cvvTextField.leftAnchor.constraint(equalTo: cvvContainer.leftAnchor).isActive = true
        cvvTextField.rightAnchor.constraint(equalTo: cvvContainer.rightAnchor).isActive = true
        cvvTextField.topAnchor.constraint(equalTo: cvvLabel.bottomAnchor, constant: 8).isActive = true
        cvvTextField.bottomAnchor.constraint(equalTo: cvvContainer.bottomAnchor).isActive = true
    }
    
    private func initPaymentNoticeLabel() {
        cardFormContainerView.addSubview(paymentNoticeIcon)
        paymentNoticeIcon.image = UIImage(named: "warning", in: Bundle.module, compatibleWith: nil)
        paymentNoticeIcon.translatesAutoresizingMaskIntoConstraints = false
        paymentNoticeIcon.leftAnchor.constraint(equalTo: cardFormContainerView.leftAnchor, constant: 18).isActive = true
        paymentNoticeIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        paymentNoticeIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true

        cardFormContainerView.addSubview(paymentNoticeLabel)
        paymentNoticeLabel.text = "window_card_payment_notice".localized(for: Kevin.shared.locale.identifier)
        paymentNoticeLabel.font = Kevin.shared.theme.generalStyle.secondaryFont
        paymentNoticeLabel.textColor = Kevin.shared.theme.generalStyle.secondaryTextColor
        paymentNoticeLabel.translatesAutoresizingMaskIntoConstraints = false
        paymentNoticeLabel.topAnchor.constraint(equalTo: paymentNoticeIcon.topAnchor).isActive = true
        paymentNoticeLabel.topAnchor.constraint(greaterThanOrEqualTo: expiryDateContainer.bottomAnchor, constant: 24).isActive = true
        paymentNoticeLabel.topAnchor.constraint(greaterThanOrEqualTo: cvvContainer.bottomAnchor, constant: 24).isActive = true
        paymentNoticeLabel.leftAnchor.constraint(equalTo: paymentNoticeIcon.rightAnchor, constant: 14).isActive = true
        paymentNoticeLabel.rightAnchor.constraint(equalTo: cardFormContainerView.rightAnchor, constant: -16).isActive = true
        paymentNoticeLabel.numberOfLines = 2
    }
    
    private func initContinueButton() {
        continueButton.clipsToBounds = false
        continueButton.layer.shadowOpacity = Kevin.shared.theme.mainButtonStyle.shadowOpacity
        continueButton.layer.shadowOffset = Kevin.shared.theme.mainButtonStyle.shadowOffset
        continueButton.layer.shadowRadius = Kevin.shared.theme.mainButtonStyle.shadowRadius
        continueButton.layer.shadowColor = Kevin.shared.theme.mainButtonStyle.shadowColor.cgColor
        continueButton.layer.cornerRadius = Kevin.shared.theme.mainButtonStyle.cornerRadius
        continueButton.backgroundColor = Kevin.shared.theme.mainButtonStyle.backgroundColor
        continueButton.titleLabel?.font = Kevin.shared.theme.mainButtonStyle.titleLabelFont
        continueButton.setTitleColor(Kevin.shared.theme.mainButtonStyle.titleLabelTextColor, for: .normal)
        continueButton.setTitle("Continue".localized(for: Kevin.shared.locale.identifier).uppercased(), for: .normal)
        cardFormContainerView.addSubview(continueButton)
        
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.bottomAnchor.constraint(equalTo: cardFormContainerView.bottomAnchor, constant: -Kevin.shared.theme.insets.bottom).isActive = true
        continueButton.widthAnchor.constraint(equalToConstant: Kevin.shared.theme.mainButtonStyle.width).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: Kevin.shared.theme.mainButtonStyle.height).isActive = true
        continueButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        continueButton.topAnchor.constraint(greaterThanOrEqualTo: paymentNoticeLabel.bottomAnchor, constant: Kevin.shared.theme.insets.top).isActive = true

        continueButton.addTarget(self, action: #selector(self.onContinueClicked(_:)), for: .touchUpInside)
    }
    
    private func initLoader() {
        loaderView.alpha = 0
        loaderView.isHidden = true

        addSubview(loaderView)
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        loaderView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        loaderView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        loaderView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    private func initBankTransferPrompt() {
        bankTransferPrompt.isHidden = true

        addSubview(bankTransferPrompt)
        bankTransferPrompt.translatesAutoresizingMaskIntoConstraints = false
        bankTransferPrompt.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bankTransferPrompt.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        bankTransferPrompt.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        bankTransferPrompt.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    @objc func keyboardWillShow() {
        guard scrollView.contentOffset.y <= 0 else {
            return
        }
        
        var point = cardNumberTextField.frame.origin
        point.x = 0

        scrollView.setContentOffset(point, animated: true)
    }
    
    @objc func keyboardWillHide() {
        guard scrollView.contentOffset.y > 0 else {
            return
        }
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }

    @objc private func onBackgroundTapped(_ sender: UITapGestureRecognizer) {
        self.endEditing(true)
    }
    
    @objc private func onContinueClicked(_ sender: UIButton) {
        self.endEditing(true)
        
        delegate?.onContinueClicked(
            cardholderName: cardholderNameTextField.textField.text ?? "",
            cardNumber: cardNumberTextField.textField.text ?? "",
            expiryDate: expiryDateTextField.textField.text ?? "",
            cvv: cvvTextField.textField.text ?? ""
        )
    }
    
    @objc private func onCvvHintTapped(_ recognizer: UITapGestureRecognizer) {
        delegate?.onCvvHintTapped()
    }
    
    private func showCardDetails(_ show: Bool) {
        // NOTE: Native UI for card payments disabled for now
        
        self.scrollView.alpha = 0
        self.webView?.alpha = 1

//        if previousCardDetailsVisibility == show {
//            return
//        }
//
//        previousCardDetailsVisibility = show
//
//        if show {
//            UIView.animate(withDuration: 0.25) {
//                self.webView?.alpha = 0
//            } completion: { _ in
//                UIView.animate(withDuration: 0.2) {
//                    self.scrollView.alpha = 1
//                }
//            }
//        } else {
//            UIView.animate(withDuration: 0.25) {
//                self.scrollView.alpha = 0
//            } completion: { _ in
//                UIView.animate(withDuration: 0.2) {
//                    self.webView?.alpha = 1
//                }
//            }
//        }
    }

    private func showLoading(_ show: Bool) {
        if previousLoadingVisibility == show {
            return
        }
        
        previousLoadingVisibility = show
        
        if show {
            self.loaderView.isHidden = false
            UIView.animate(withDuration: 0.25) {
                self.loaderView.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.25) {
                self.loaderView.alpha = 0
            } completion: { _ in
                self.loaderView.isHidden = true
            }
        }
    }
}

extension KevinCardPaymentView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case cardNumberTextField.textField,
             expiryDateTextField.textField,
             cvvTextField.textField:
            return string.isNumeric || string.isEmpty
        case cardholderNameTextField.textField:
            return !string.isNumeric || string.isEmpty
        default:
            return true
        }
    }
    
    @objc func onTextFieldEdited(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        switch textField {
        case cardNumberTextField.textField:
            textField.text = text.removeNonNumericCharacters().prefixString(16).formatAsCardNumber()
            webView?.evaluateJavaScript("window.cardDetails.setCardNumber('\(text.removeNonNumericCharacters())');") {_,_ in }
        case expiryDateTextField.textField:
            textField.text = text.removeNonNumericCharacters().prefixString(4).formatAsExpiryDate()
        case cvvTextField.textField:
            textField.text = text.removeNonNumericCharacters().prefixString(3)
        default:
            return
        }
    }
}

extension KevinCardPaymentView {
    
    func showFormErrors(
        isCardholderNameValid: KevinValidationResult,
        isCardNumberValid: KevinValidationResult,
        isExpiryDateValid: KevinValidationResult,
        isCvvValid: KevinValidationResult
    ) {
        cardNumberTextField.setError(isCardNumberValid.errorMessage)
        cardholderNameTextField.setError(isCardholderNameValid.errorMessage)
        expiryDateTextField.setError(isExpiryDateValid.errorMessage)
        cvvTextField.setError(isCvvValid.errorMessage)
    }
    
    func submitForm(cardholderName: String, cardNumber: String, expiryDate: String, cvv: String) {
        guard let webView = webView else {
            return
        }
        
        webView.evaluateJavaScript("window.cardDetails.setCardholderName('\(cardholderName)');") {_,_ in }
        webView.evaluateJavaScript("window.cardDetails.setCardNumber('\(cardNumber.removeNonNumericCharacters())');") {_,_ in }
        webView.evaluateJavaScript("window.cardDetails.setExpirationDate('\(expiryDate)');") {_,_ in }
        webView.evaluateJavaScript("window.cardDetails.setCsc('\(cvv)');") {_,_ in }
        webView.evaluateJavaScript("window.cardDetails.submitForm();") {_,_ in }
    }
    
    func showUserRedirectPrompt(bankName: String) {
        self.endEditing(true)
        
        bankTransferPrompt.bankName = bankName
        bankTransferPrompt.delegate = delegate
        bankTransferPrompt.isHidden = false
        bankTransferPrompt.animatePresentContainer()
    }
    
    func submitUserRedirect(shouldRedirect: Bool) {
        guard let webView = webView else {
            return
        }
        
        bankTransferPrompt.animateHideContainer {
            self.bankTransferPrompt.isHidden = true
        }
        
        if shouldRedirect {
            webView.evaluateJavaScript("window.cardDetails.confirmBank();") {_,_ in }
        } else {
            webView.evaluateJavaScript("window.cardDetails.cancelBank();") {_,_ in }
        }
    }
}

extension KevinCardPaymentView: WKScriptMessageHandler, WKNavigationDelegate {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == handlerName {
            guard let messageBody = message.body as? String else {
                return
            }
            
            switch messageBody {
            case KevinCardPaymentEvent.softRedirect().getRawValue():
                delegate?.onEvent(event: .softRedirect(
                    cardNumber: cardNumberTextField.textField.text?.removeNonNumericCharacters() ?? "")
                )
            case KevinCardPaymentEvent.hardRedirect.getRawValue():
                delegate?.onEvent(event: .hardRedirect)
            case KevinCardPaymentEvent.submittingCardData.getRawValue():
                delegate?.onEvent(event: .submittingCardData)
            default:
                break
            }
        }
    }

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }

        do {
            let callbackUrl = try KevinInAppPaymentsPlugin.shared.getCallbackUrl()
            if url.absoluteString.starts(with: callbackUrl.absoluteString) {
                delegate?.onPaymentResult(callbackUrl: url, error: nil)
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        } catch {
            delegate?.onPaymentResult(callbackUrl: url, error: error)
            decisionHandler(.allow)
        }
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        delegate?.onPageStartLoading()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("window.cardDetails.enableEventMessages();") {_,_ in }
        delegate?.onPageFinishedLoading()
    }
}
