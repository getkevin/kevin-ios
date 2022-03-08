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

    private let handlerName = "KevinCardPaymentView"

    private let cardForm = UIView()
    private let cardIconView = UIImageView()
    private let amountLabel = UILabel()
    private let paymentTypeLabel = UILabel()
    private let cardNumberLabel = UILabel()
    private let cardNumberTextField = KevinTextField()
    private let cardholderNameLabel = UILabel()
    private let cardholderNameTextField = KevinTextField()
    private let expiryDateContainer = UIView()
    private let expiryDateLabel = UILabel()
    private let expiryDateTextField = KevinTextField()
    private let cvvContainer = UIView()
    private let cvvLabel = UILabel()
    private let cvvLabelHint = UILabel()
    private let cvvTextField = KevinTextField()
    private let paymentNoticeIcon = UIImageView()
    private let paymentNoticeLabel = UILabel()
    private let continueButton = KevinButton(type: .custom)
    
    private var webView: WKWebView?

    override func render(state: KevinCardPaymentState) {
        webView?.load(URLRequest(url: state.url))
        amountLabel.text = state.amount ?? ""
    }

    override func viewDidLoad() {
        backgroundColor = Kevin.shared.theme.generalStyle.primaryBackgroundColor
        
        let tapGestureBackground = UITapGestureRecognizer(target: self, action: #selector(self.backgroundTapped(_:)))
        self.addGestureRecognizer(tapGestureBackground)
        
        initWebView()
        initCardForm()
        initAmountContainer()
        initCardNumberInput()
        initCardholderNameInput()
        initExpiryDateAndCvvContainers()
        initPaymentNoticeLabel()
        initContinueButton()
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
        }
        
        // TODO: Implement JavaScript callback observers
        // SOFT_REDIRECT_MODAL
        // HARD_REDIRECT_MODAL
        // CARD_PAYMENT_SUBMITTING
        
        // TODO: Add page lifecycle observers
        // onPageStarted
        // onPageFinished
    }
    
    private func initCardForm() {
        cardForm.backgroundColor = Kevin.shared.theme.generalStyle.primaryBackgroundColor

        addSubview(cardForm)
        cardForm.translatesAutoresizingMaskIntoConstraints = false
        cardForm.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cardForm.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        cardForm.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        cardForm.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    private func initAmountContainer() {
        cardForm.addSubview(cardIconView)
        cardIconView.image = UIImage(named: "card", in: Bundle.module, compatibleWith: nil)
        cardIconView.translatesAutoresizingMaskIntoConstraints = false
        cardIconView.centerXAnchor.constraint(equalTo: cardForm.centerXAnchor).isActive = true
        cardIconView.topAnchor.constraint(equalTo: cardForm.topAnchor, constant: 0).isActive = true
        cardIconView.widthAnchor.constraint(equalToConstant: 56).isActive = true
        cardIconView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        cardForm.addSubview(amountLabel)
        amountLabel.text = ""
        amountLabel.font = Kevin.shared.theme.cardPaymentStyle.amountLabelFont
        amountLabel.textColor = Kevin.shared.theme.cardPaymentStyle.amountLabelTextColor
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.centerXAnchor.constraint(equalTo: cardForm.centerXAnchor).isActive = true
        amountLabel.topAnchor.constraint(equalTo: cardIconView.bottomAnchor, constant: 16).isActive = true

        cardForm.addSubview(paymentTypeLabel)
        paymentTypeLabel.text = "window_card_payment_label".localized(for: Kevin.shared.locale.identifier)
        paymentTypeLabel.font = Kevin.shared.theme.cardPaymentStyle.fieldNameLabelFont
        paymentTypeLabel.textColor = Kevin.shared.theme.cardPaymentStyle.fieldNameLabelTextColor
        paymentTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        paymentTypeLabel.centerXAnchor.constraint(equalTo: cardForm.centerXAnchor).isActive = true
        paymentTypeLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 8).isActive = true
    }
        
    private func initCardNumberInput() {
        cardForm.addSubview(cardNumberLabel)
        cardNumberLabel.text = "window_card_payment_card_number_label".localized(for: Kevin.shared.locale.identifier)
        cardNumberLabel.font = Kevin.shared.theme.cardPaymentStyle.fieldNameLabelFont
        cardNumberLabel.textColor = Kevin.shared.theme.cardPaymentStyle.fieldNameLabelTextColor
        cardNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        cardNumberLabel.leftAnchor.constraint(equalTo: cardForm.leftAnchor, constant: 16).isActive = true
        cardNumberLabel.rightAnchor.constraint(equalTo: cardForm.rightAnchor, constant: 16).isActive = true
        cardNumberLabel.topAnchor.constraint(equalTo: paymentTypeLabel.bottomAnchor, constant: 38).isActive = true

        cardForm.addSubview(cardNumberTextField)
        cardNumberTextField.placeholder = "window_card_payment_card_number_hint".localized(for: Kevin.shared.locale.identifier)
        cardNumberTextField.placeholderColor = Kevin.shared.theme.cardPaymentStyle.fieldNameLabelTextColor
        cardNumberTextField.font = Kevin.shared.theme.cardPaymentStyle.textFieldFont
        cardNumberTextField.textColor = Kevin.shared.theme.cardPaymentStyle.textFieldTextColor
        cardNumberTextField.backgroundColor = Kevin.shared.theme.cardPaymentStyle.textFieldBackgroundColor
        cardNumberTextField.layer.cornerRadius = Kevin.shared.theme.cardPaymentStyle.textFieldCornerRadius
        cardNumberTextField.layer.borderColor = Kevin.shared.theme.cardPaymentStyle.textFieldBorderColor.cgColor
        cardNumberTextField.layer.borderWidth = Kevin.shared.theme.cardPaymentStyle.textFieldBorderWidth
        cardNumberTextField.autocorrectionType = .no
        cardNumberTextField.keyboardType = .numberPad
        cardNumberTextField.clearButtonMode = .whileEditing
        cardNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        cardNumberTextField.leftAnchor.constraint(equalTo: cardForm.leftAnchor, constant: 16).isActive = true
        cardNumberTextField.rightAnchor.constraint(equalTo: cardForm.rightAnchor, constant: -16).isActive = true
        cardNumberTextField.topAnchor.constraint(equalTo: cardNumberLabel.bottomAnchor, constant: 8).isActive = true
        cardNumberTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        cardNumberTextField.delegate = self
        cardNumberTextField.addTarget(self, action: #selector(onTextFieldEdited(_:)), for: .editingChanged)
    }
    
    private func initCardholderNameInput() {
        cardForm.addSubview(cardholderNameLabel)
        cardholderNameLabel.text = "window_card_payment_cardholder_name_label".localized(for: Kevin.shared.locale.identifier)
        cardholderNameLabel.font = Kevin.shared.theme.cardPaymentStyle.fieldNameLabelFont
        cardholderNameLabel.textColor = Kevin.shared.theme.cardPaymentStyle.fieldNameLabelTextColor
        cardholderNameLabel.translatesAutoresizingMaskIntoConstraints = false
        cardholderNameLabel.leftAnchor.constraint(equalTo: cardForm.leftAnchor, constant: 16).isActive = true
        cardholderNameLabel.rightAnchor.constraint(equalTo: cardForm.rightAnchor, constant: 16).isActive = true
        cardholderNameLabel.topAnchor.constraint(equalTo: cardNumberTextField.bottomAnchor, constant: 27).isActive = true

        cardForm.addSubview(cardholderNameTextField)
        cardholderNameTextField.placeholder = "window_card_payment_cardholder_name_hint".localized(for: Kevin.shared.locale.identifier)
        cardholderNameTextField.placeholderColor = Kevin.shared.theme.cardPaymentStyle.fieldNameLabelTextColor
        cardholderNameTextField.font = Kevin.shared.theme.cardPaymentStyle.textFieldFont
        cardholderNameTextField.textColor = Kevin.shared.theme.cardPaymentStyle.textFieldTextColor
        cardholderNameTextField.backgroundColor = Kevin.shared.theme.cardPaymentStyle.textFieldBackgroundColor
        cardholderNameTextField.layer.cornerRadius = Kevin.shared.theme.cardPaymentStyle.textFieldCornerRadius
        cardholderNameTextField.layer.borderColor = Kevin.shared.theme.cardPaymentStyle.textFieldBorderColor.cgColor
        cardholderNameTextField.layer.borderWidth = Kevin.shared.theme.cardPaymentStyle.textFieldBorderWidth
        cardholderNameTextField.autocorrectionType = .no
        cardholderNameTextField.autocapitalizationType = .words
        cardholderNameTextField.clearButtonMode = .whileEditing
        cardholderNameTextField.translatesAutoresizingMaskIntoConstraints = false
        cardholderNameTextField.leftAnchor.constraint(equalTo: cardForm.leftAnchor, constant: 16).isActive = true
        cardholderNameTextField.rightAnchor.constraint(equalTo: cardForm.rightAnchor, constant: -16).isActive = true
        cardholderNameTextField.topAnchor.constraint(equalTo: cardholderNameLabel.bottomAnchor, constant: 8).isActive = true
        cardholderNameTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        cardholderNameTextField.delegate = self
        cardholderNameTextField.addTarget(self, action: #selector(onTextFieldEdited(_:)), for: .editingChanged)
    }

    private func initExpiryDateAndCvvContainers() {
        cardForm.addSubview(expiryDateContainer)
        expiryDateContainer.backgroundColor = .clear
        expiryDateContainer.translatesAutoresizingMaskIntoConstraints = false
        expiryDateContainer.leftAnchor.constraint(equalTo: cardForm.leftAnchor, constant: 16).isActive = true
        expiryDateContainer.topAnchor.constraint(equalTo: cardholderNameTextField.bottomAnchor, constant: 27).isActive = true
        initExpiryDateInput()
        
        cardForm.addSubview(cvvContainer)
        cvvContainer.backgroundColor = .clear
        cvvContainer.translatesAutoresizingMaskIntoConstraints = false
        cvvContainer.leftAnchor.constraint(equalTo: expiryDateContainer.rightAnchor, constant: 32).isActive = true
        cvvContainer.rightAnchor.constraint(equalTo: cardForm.rightAnchor, constant: -16).isActive = true
        cvvContainer.topAnchor.constraint(equalTo: cardholderNameTextField.bottomAnchor, constant: 27).isActive = true
        cvvContainer.widthAnchor.constraint(equalTo: expiryDateContainer.widthAnchor).isActive = true
        initCvvInput()
    }
    
    private func initExpiryDateInput() {
        expiryDateContainer.addSubview(expiryDateLabel)
        expiryDateLabel.text = "window_card_payment_expiry_date_label".localized(for: Kevin.shared.locale.identifier)
        expiryDateLabel.font = Kevin.shared.theme.cardPaymentStyle.fieldNameLabelFont
        expiryDateLabel.textColor = Kevin.shared.theme.cardPaymentStyle.fieldNameLabelTextColor
        expiryDateLabel.translatesAutoresizingMaskIntoConstraints = false
        expiryDateLabel.leftAnchor.constraint(equalTo: expiryDateContainer.leftAnchor).isActive = true
        expiryDateLabel.rightAnchor.constraint(equalTo: expiryDateContainer.rightAnchor).isActive = true
        expiryDateLabel.topAnchor.constraint(equalTo: expiryDateContainer.topAnchor).isActive = true
        
        expiryDateContainer.addSubview(expiryDateTextField)
        expiryDateTextField.placeholder = "window_card_payment_expiry_date_hint".localized(for: Kevin.shared.locale.identifier)
        expiryDateTextField.placeholderColor = Kevin.shared.theme.cardPaymentStyle.fieldNameLabelTextColor
        expiryDateTextField.font = Kevin.shared.theme.cardPaymentStyle.textFieldFont
        expiryDateTextField.textColor = Kevin.shared.theme.cardPaymentStyle.textFieldTextColor
        expiryDateTextField.backgroundColor = Kevin.shared.theme.cardPaymentStyle.textFieldBackgroundColor
        expiryDateTextField.layer.cornerRadius = Kevin.shared.theme.cardPaymentStyle.textFieldCornerRadius
        expiryDateTextField.layer.borderColor = Kevin.shared.theme.cardPaymentStyle.textFieldBorderColor.cgColor
        expiryDateTextField.layer.borderWidth = Kevin.shared.theme.cardPaymentStyle.textFieldBorderWidth
        expiryDateTextField.autocorrectionType = .no
        expiryDateTextField.keyboardType = .numberPad
        expiryDateTextField.clearButtonMode = .whileEditing
        expiryDateTextField.translatesAutoresizingMaskIntoConstraints = false
        expiryDateTextField.leftAnchor.constraint(equalTo: expiryDateContainer.leftAnchor).isActive = true
        expiryDateTextField.rightAnchor.constraint(equalTo: expiryDateContainer.rightAnchor).isActive = true
        expiryDateTextField.topAnchor.constraint(equalTo: expiryDateLabel.bottomAnchor, constant: 8).isActive = true
        expiryDateTextField.bottomAnchor.constraint(equalTo: expiryDateContainer.bottomAnchor).isActive = true
        expiryDateTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        expiryDateTextField.delegate = self
        expiryDateTextField.addTarget(self, action: #selector(onTextFieldEdited(_:)), for: .editingChanged)
    }

    private func initCvvInput() {
        cvvContainer.addSubview(cvvLabel)
        cvvLabel.text = "window_card_payment_cvv_label".localized(for: Kevin.shared.locale.identifier)
        cvvLabel.font = Kevin.shared.theme.cardPaymentStyle.fieldNameLabelFont
        cvvLabel.textColor = Kevin.shared.theme.cardPaymentStyle.fieldNameLabelTextColor
        cvvLabel.translatesAutoresizingMaskIntoConstraints = false
        cvvLabel.leftAnchor.constraint(equalTo: cvvContainer.leftAnchor).isActive = true
        cvvLabel.topAnchor.constraint(equalTo: cvvContainer.topAnchor).isActive = true
        cvvLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        cvvContainer.addSubview(cvvLabelHint)
        cvvLabelHint.text = "􀁜"
        cvvLabelHint.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cvvLabelHint.textColor = Kevin.shared.theme.mainButtonStyle.backgroundColor
        cvvLabelHint.translatesAutoresizingMaskIntoConstraints = false
        cvvLabelHint.leftAnchor.constraint(equalTo: cvvLabel.rightAnchor, constant: 4).isActive = true
        cvvLabelHint.rightAnchor.constraint(equalTo: cvvContainer.rightAnchor).isActive = true
        cvvLabelHint.bottomAnchor.constraint(equalTo: cvvLabel.bottomAnchor).isActive = true
        
        // TODO: Implement cvv hint action

        cvvContainer.addSubview(cvvTextField)
        cvvTextField.placeholder = "window_card_payment_cvv_hint".localized(for: Kevin.shared.locale.identifier)
        cvvTextField.placeholderColor = Kevin.shared.theme.cardPaymentStyle.fieldNameLabelTextColor
        cvvTextField.font = Kevin.shared.theme.cardPaymentStyle.textFieldFont
        cvvTextField.textColor = Kevin.shared.theme.cardPaymentStyle.textFieldTextColor
        cvvTextField.backgroundColor = Kevin.shared.theme.cardPaymentStyle.textFieldBackgroundColor
        cvvTextField.layer.cornerRadius = Kevin.shared.theme.cardPaymentStyle.textFieldCornerRadius
        cvvTextField.layer.borderColor = Kevin.shared.theme.cardPaymentStyle.textFieldBorderColor.cgColor
        cvvTextField.layer.borderWidth = Kevin.shared.theme.cardPaymentStyle.textFieldBorderWidth
        cvvTextField.autocorrectionType = .no
        cvvTextField.keyboardType = .numberPad
        cvvTextField.clearButtonMode = .whileEditing
        cvvTextField.translatesAutoresizingMaskIntoConstraints = false
        cvvTextField.leftAnchor.constraint(equalTo: cvvContainer.leftAnchor).isActive = true
        cvvTextField.rightAnchor.constraint(equalTo: cvvContainer.rightAnchor).isActive = true
        cvvTextField.topAnchor.constraint(equalTo: cvvLabel.bottomAnchor, constant: 8).isActive = true
        cvvTextField.bottomAnchor.constraint(equalTo: cvvContainer.bottomAnchor).isActive = true
        cvvTextField.heightAnchor.constraint(equalToConstant: 44).isActive = true
        cvvTextField.delegate = self
        cvvTextField.addTarget(self, action: #selector(onTextFieldEdited(_:)), for: .editingChanged)
    }
    
    private func initPaymentNoticeLabel() {
        cardForm.addSubview(paymentNoticeIcon)
        paymentNoticeIcon.image = UIImage(named: "warning", in: Bundle.module, compatibleWith: nil)
        paymentNoticeIcon.translatesAutoresizingMaskIntoConstraints = false
        paymentNoticeIcon.topAnchor.constraint(equalTo: expiryDateContainer.bottomAnchor, constant: 22).isActive = true
        paymentNoticeIcon.leftAnchor.constraint(equalTo: cardForm.leftAnchor, constant: 18).isActive = true
        paymentNoticeIcon.widthAnchor.constraint(equalToConstant: 20).isActive = true
        paymentNoticeIcon.heightAnchor.constraint(equalToConstant: 20).isActive = true

        cardForm.addSubview(paymentNoticeLabel)
        paymentNoticeLabel.text = "window_card_payment_notice".localized(for: Kevin.shared.locale.identifier)
        paymentNoticeLabel.font = Kevin.shared.theme.cardPaymentStyle.fieldNameLabelFont
        paymentNoticeLabel.textColor = Kevin.shared.theme.cardPaymentStyle.fieldNameLabelTextColor
        paymentNoticeLabel.translatesAutoresizingMaskIntoConstraints = false
        paymentNoticeLabel.topAnchor.constraint(equalTo: expiryDateContainer.bottomAnchor, constant: 24).isActive = true
        paymentNoticeLabel.leftAnchor.constraint(equalTo: paymentNoticeIcon.rightAnchor, constant: 14).isActive = true
        paymentNoticeLabel.rightAnchor.constraint(equalTo: cardForm.rightAnchor, constant: -16).isActive = true
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
        continueButton.setTitle("action_continue".localized(for: Kevin.shared.locale.identifier).uppercased(), for: .normal)
        cardForm.addSubview(continueButton)
        
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Kevin.shared.theme.insets.bottom).isActive = true
        continueButton.widthAnchor.constraint(equalToConstant: Kevin.shared.theme.mainButtonStyle.width).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: Kevin.shared.theme.mainButtonStyle.height).isActive = true
        continueButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        continueButton.addTarget(self, action: #selector(self.onContinueClicked(_:)), for: .touchUpInside)
    }
    
    @objc private func backgroundTapped(_ sender: UITapGestureRecognizer) {
        self.endEditing(true)
    }
    
    @objc private func onContinueClicked(_ sender: UIButton) {
        self.endEditing(true)
        
        delegate?.onContinueClicked(
            cardholderName: cardholderNameTextField.text ?? "",
            cardNumber: cardNumberTextField.text ?? "",
            expiryDate: expiryDateTextField.text ?? "",
            cvv: cvvTextField.text ?? ""
        )
    }
}

extension KevinCardPaymentView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let kevinTextField = textField as? KevinTextField else {
            return false
        }
                
        switch kevinTextField {
        case cardNumberTextField,
             expiryDateTextField,
             cvvTextField:
            return string.isNumeric || string.isEmpty
        case cardholderNameTextField:
            return !string.isNumeric || string.isEmpty
        default:
            return true
        }
    }
    
    @objc func onTextFieldEdited(_ textField: UITextField) {
        guard let kevinTextField = textField as? KevinTextField else {
            return
        }
        
        kevinTextField.hideError()
        
        guard let text = kevinTextField.text else {
            return
        }
        
        switch kevinTextField {
        case cardNumberTextField:
            kevinTextField.text = text.removeNonNumericCharacters().prefixString(16).formatAsCardNumber()
        case expiryDateTextField:
            kevinTextField.text = text.removeNonNumericCharacters().prefixString(4).formatAsExpiryDate()
        case cvvTextField:
            kevinTextField.text = text.removeNonNumericCharacters().prefixString(3)
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
        cardholderNameTextField.showError(isCardholderNameValid.errorMessage)
        cardNumberTextField.showError(isCardNumberValid.errorMessage)
        expiryDateTextField.showError(isExpiryDateValid.errorMessage)
        cvvTextField.showError(isCvvValid.errorMessage)
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
}

extension KevinCardPaymentView: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // TODO: ?
    }
}
