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


class BaseViewController: UIViewController {
    var url:URLRequest! = URLRequest(url: URL(string: readConfig().storeURL)!)
    var webview: WKWebView?
    override func loadView() {
        super.loadView()
        let webView = OMFWebView(frame: .zero)
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        webview = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        webview?.load(url)
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
