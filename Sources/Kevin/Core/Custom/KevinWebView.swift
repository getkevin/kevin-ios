//
//  KevinWebView.swift
//  
//
//  Created by Arthur Alehna on 19/04/2023.
//  Copyright © 2023 kevin.. All rights reserved.
//

import WebKit

internal class KevinWebView: WKWebView, WKNavigationDelegate {
    
    typealias CompletedCallback = (URL, Error?) -> ()
    var completedCallback: CompletedCallback? = nil
    
    private let loadingIndicator = UIActivityIndicatorView()
    private let callbackURL: URL
    
    init(callbackURL: URL) {
        self.callbackURL = callbackURL
        super.init(frame: .zero, configuration: .init())
        
        navigationDelegate = self
        commonInit()
        initLoadingIndicator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLoadingIndicator() {
        addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.center(in: self)
        loadingIndicator.startAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIndicator.stopAnimating()
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
        
        if url.absoluteString.starts(with: callbackURL.absoluteString) {
            decisionHandler(.cancel)
            completedCallback?(url, nil)
        } else if shouldProcessExternally(url: url) {
            processUrlExternally(url, decisionHandler: decisionHandler)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func processUrlExternally(
        _ url: URL,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [.universalLinksOnly: true]) { isSuccess in
                if isSuccess {
                    decisionHandler(.cancel)
                } else {
                    decisionHandler(.allow)
                }
            }
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func shouldProcessExternally(url: URL) -> Bool {
        if url.scheme == "tel" || url.scheme == "mailto" {
            return true
        }
        
        if Kevin.shared.isDeepLinkingEnabled && (url.scheme == "http" || url.scheme == "https") {
            return url.host != KevinApiPaths.host
        }
        
        return false
    }
}
