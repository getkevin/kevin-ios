//
//  KevinAccountLinkingView.swift
//  kevin.iOS
//
//  Created by Edgar Žigis on 8/1/21.
//  Copyright © 2021 kevin.. All rights reserved.
//

import UIKit
import WebKit

internal class KevinAccountLinkingView: KevinView<KevinAccountLinkingState> {
    
    weak var delegate: KevinAccountLinkingViewDelegate?
    
    private let webView = WKWebView()
    private let loadingIndicator = UIActivityIndicatorView()
    
    override func render(state: KevinAccountLinkingState) {
        webView.load(URLRequest(url: state.bankRedirectUrl))
    }
    
    override func viewDidLoad() {
        backgroundColor = Kevin.shared.theme.generalStyle.primaryBackgroundColor
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

extension KevinAccountLinkingView: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIndicator.stopAnimating()
        guard let url = webView.url else {
            return
        }
        do {
            let callbackUrl = try KevinAccountsPlugin.shared.getCallbackUrl()
            if url.absoluteString.starts(with: callbackUrl.absoluteString) {
                delegate?.onAccountLinkingCompleted(callbackUrl: url, error: nil)
            }
        } catch {
            delegate?.onAccountLinkingCompleted(callbackUrl: url, error: error)
        }
    }
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if shouldProcessExternally(url: navigationAction.request.url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(
                    navigationAction.request.url!,
                    options: [.universalLinksOnly: true]
                ) { isSuccess in
                    if isSuccess {
                        decisionHandler(.cancel)
                    } else {
                        decisionHandler(.allow)
                    }
                }
            } else {
                decisionHandler(.allow)
            }
        } else {
            decisionHandler(.allow)
        }
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation: WKNavigation!, withError: Error) {
        guard let url = webView.url else {
            return
        }

        delegate?.onAccountLinkingCompleted(callbackUrl: url, error: withError)
    }
    
    private func shouldProcessExternally(url: URL?) -> Bool {
        guard let url = url else {
            return false
        }
        
        if url.scheme == "tel" || url.scheme == "mailto" {
            return true
        }
        
        if Kevin.shared.isDeepLinkingEnabled {
            if (url.scheme == "http" || url.scheme == "https") {
                return url.host != KevinApiPaths.host
            }
        }
        
        return false
    }
}
