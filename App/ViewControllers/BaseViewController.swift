//
//  ViewControllers.swift
//  MobileAppSourceCodeV1
//
//  Created by Himanshu Singh on 22/10/23.
//

import Foundation
import UIKit
import WebKit
import Network
import Reachability

class OMFWebView: WKWebView {
    
}

class BaseViewController: UIViewController {
    var url:URLRequest! = URLRequest(url: URL(string: readConfig().storeURL)!)
    private var webview: WKWebView?
    private var activityIndicator: UIActivityIndicatorView!
    private var reachability: Reachability?
    private var webViewObservation: NSKeyValueObservation?
    private let refreshControl = UIRefreshControl()
    
    private lazy var noInternetView: ErrorView = {
        let view = ErrorView(title: "You are offline. Please try again!", image: Asset.error_dog, buttonTitle: "Retry", buttonAction: UIAction(handler: { [unowned self] _ in
            checkForNetwork()
            self.refreshWebView(refreshControl)
        }))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

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
        addRefreshControl()
        addLoadingIndicator()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webview?.load(url)
    }
}

// WebView Configuration for Log Network Calls
extension BaseViewController {
    private func webViewConfiguration() -> WKWebViewConfiguration {
        let configuration = WKWebViewConfiguration()
        let contentController = configuration.userContentController
        contentController.add(self, name: "networkResponse")
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

// Refresh Control
extension BaseViewController {
    private func addRefreshControl() {
        webview?.scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshWebView), for: .valueChanged)
    }
    
    @objc private func refreshWebView(_ sender: UIRefreshControl) {
        webview?.reload()
        sender.endRefreshing()
    }
}

// Loading Activity Indicator
extension BaseViewController {
    private func addLoadingIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .gray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.startAnimating()
        
        webViewObservation = webview?.observe(\.estimatedProgress, options: [.new]) { [weak self] webView, _ in
            guard let self = self else { return }
            if webView.estimatedProgress > 0.3 {
                self.activityIndicator.stopAnimating()
                self.webViewObservation?.invalidate()
            }
        }
    }
}

// Network connection
extension BaseViewController {
    private func checkForNetwork() {
        reachability = try? Reachability()
        reachability?.connection == .unavailable ? showNoInternet() : hideNoInternet()
    }
    
    func showNoInternet() {
        let errorView = self.view.subviews.first(where: { $0.tag == 101})
        if errorView == nil {
            self.view.addSubview(noInternetView)
            NSLayoutConstraint.activate([
                noInternetView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                noInternetView.topAnchor.constraint(equalTo: self.view.topAnchor),
                noInternetView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                noInternetView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ])
        } else {
            return
        }
    }
    
    func hideNoInternet() {
        let errorView = self.view.subviews.first(where: { $0.tag == 101})
        if let errorView = errorView {
            errorView.removeFromSuperview()
        } else {
            return
        }
    }
}


extension BaseViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "networkResponse" {
            if let body = message.body as? String {
                print("Network Call Response: \(body)")
            }
        }
    }
}

extension BaseViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        checkForNetwork()
        decisionHandler(.allow)
    }
}
