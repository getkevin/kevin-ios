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
    
    private var webView: KevinWebView?
    
    override func render(state: KevinAccountLinkingState) {
        webView?.load(URLRequest(url: state.bankRedirectUrl))
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
            webView.completedCallback = { [weak self] url, error in
                self?.delegate?.onAccountLinkingCompleted(callbackUrl: url, error: error)
            }
        } catch {
            delegate?.onAccountLinkingCompleted(callbackUrl: nil, error: error)
        }
    }
}
