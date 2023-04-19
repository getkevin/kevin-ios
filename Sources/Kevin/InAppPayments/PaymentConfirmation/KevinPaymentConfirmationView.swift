//
//  KevinPaymentConfirmationView.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import UIKit
import WebKit

internal class KevinPaymentConfirmationView: KevinView<KevinPaymentConfirmationState> {
    
    weak var delegate: KevinPaymentConfirmationViewDelegate?
    
    private var webView: KevinWebView?
    
    override func render(state: KevinPaymentConfirmationState) {
        webView?.load(URLRequest(url: state.url))
    }
    
    override func viewDidLoad() {
        backgroundColor = Kevin.shared.theme.generalStyle.primaryBackgroundColor
        initWebView()
    }
    
    private func initWebView() {
        do {
            let callbackUrl = try KevinAccountsPlugin.shared.getCallbackUrl()
            let webView = KevinWebView(callbackURL: callbackUrl)
            self.webView = webView
            
            addSubview(webView)
            webView.translatesAutoresizingMaskIntoConstraints = false
            webView.fill(in: self)
            webView.paymentCompletedCallback = { [weak self] url, error in
                self?.delegate?.onPaymentCompleted(callbackUrl: url, error: error)
            }
        } catch {
            delegate?.onPaymentCompleted(callbackUrl: nil, error: error)
        }
    }
}
