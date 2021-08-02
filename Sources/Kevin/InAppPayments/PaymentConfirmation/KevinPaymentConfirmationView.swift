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
    
    private let webView = WKWebView()
    private let loadingIndicator = UIActivityIndicatorView()
    
    override func render(state: KevinPaymentConfirmationState) {
        webView.load(URLRequest(url: state.url))
    }
    
    override func viewDidLoad() {
        backgroundColor = Kevin.shared.theme.primaryBackgroundColor
        initWebView()
        initLoadingIndicator()
    }
    
    private func initWebView() {
        addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.fill(in: self)
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.allowsLinkPreview = true
    }
    
    private func initLoadingIndicator() {
        addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.center(in: self)
        loadingIndicator.startAnimating()
    }
}

extension KevinPaymentConfirmationView: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIndicator.stopAnimating()
        guard let url = webView.url else {
            return
        }
        do {
            let callbackUrl = try KevinInAppPaymentsPlugin.shared.getCallbackUrl()
            if url.absoluteString.starts(with: callbackUrl.absoluteString) {
                delegate?.onPaymentCompleted(callbackUrl: url, error: nil)
            }
        } catch {
            delegate?.onPaymentCompleted(callbackUrl: url, error: error)
        }
    }
}
