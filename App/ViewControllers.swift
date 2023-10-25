//
//  ViewControllers.swift
//  MobileAppSourceCodeV1
//
//  Created by Himanshu Singh on 22/10/23.
//

import Foundation
import UIKit
import WebKit

class OMFWebView: WKWebView {
    
}

extension BaseViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
}

extension BaseViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "networkResponse" {
            if let body = message.body as? String {
                print("Network Call Response: \(body)")
                // Call any function or perform any action here in response to the button tap
            }
        }
    }
}


class BaseViewController: UIViewController {
    var url:URLRequest! = URLRequest(url: URL(string: readConfig().storeURL)!)
    var webview: WKWebView?
    override func loadView() {
        super.loadView()
        let webView = OMFWebView(frame: .zero, configuration: self.webViewConfiguration())
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        webview = webView
        webview?.navigationDelegate = self
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        webview?.load(url)
    }
    
    private func webViewConfiguration() -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        let contentController = configuration.userContentController
        contentController.add(self, name: "networkResponse")
        // JavaScript to listen for all Network call response and post a message.
        let scriptSource = """
            var originalXhrOpen = window.XMLHttpRequest.prototype.open;
            var originalXhrSend = window.XMLHttpRequest.prototype.send;
            window.XMLHttpRequest.prototype.open = function(method, url) {
                this._url = url;
                return originalXhrOpen.apply(this, arguments);
            };
            window.XMLHttpRequest.prototype.send = function(body) {
                var self = this;
                var oldOnReadyStateChange;
                var url = this._url;
                function onReadyStateChange() {
                    if (self.readyState === 4) {
                        window.webkit.messageHandlers.networkResponse.postMessage(self.responseText);
                    }
                    if (oldOnReadyStateChange) {
                        oldOnReadyStateChange();
                    }
                }
                if (this.onreadystatechange) {
                    oldOnReadyStateChange = this.onreadystatechange;
                }
                this.onreadystatechange = onReadyStateChange;
                return originalXhrSend.apply(this, arguments);
            };
        """
        let script = WKUserScript(source: scriptSource, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        contentController.addUserScript(script)
        return configuration
    }
}

class Home: BaseViewController {
    
}
class All: BaseViewController {
    override var url: URLRequest! {
        get {
            URLRequest(url: URL(string: readConfig().storeURL + "/collections/all")!)
        }
        set{}
    }
}
class Account: BaseViewController {
    override var url: URLRequest! {
        get {
            URLRequest(url: URL(string: readConfig().storeURL + "/account")!)
        }
        set{}
    }
}
class Cart: BaseViewController {
    override var url: URLRequest! {
        get {
            URLRequest(url: URL(string: readConfig().storeURL + "/cart")!)
        }
        set{}
    }
}
