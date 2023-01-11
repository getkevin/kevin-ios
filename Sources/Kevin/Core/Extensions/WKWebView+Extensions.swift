import WebKit

internal extension WKWebView {
    
    func commonInit() {
        if let currentUserAgent = WKWebView().value(forKey: "userAgent") as? String {
            customUserAgent = "\(currentUserAgent) \(UserAgent.userAgentString)"
        }
        allowsBackForwardNavigationGestures = true
        allowsLinkPreview = true
    }
}
