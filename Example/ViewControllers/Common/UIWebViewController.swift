//
//  UIWebViewController.swift
//  Example
//
//  Created by 王芃 on 2019/2/23.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import Layout
import NVActivityIndicatorView

class UIWebViewController: BaseViewController, LayoutLoading {
    @objc weak var webView: UIWebView!
    @objc weak var activityIndicatorView: NVActivityIndicatorView!
    @objc weak var loadingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLayout(named: "UIWebViewController.xml")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (self.isMovingFromParent) {
            self.webView.loadHTMLString("", baseURL: nil)
        }
    }
    
    func layoutDidLoad(_: LayoutNode) {
        
    }
}

extension UIWebViewController: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        return true
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        if (!self.activityIndicatorView.isAnimating) {
            self.activityIndicatorView.startAnimating()
            self.loadingLabel.isHidden = false
        }
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if (self.activityIndicatorView.isAnimating) {
            self.activityIndicatorView.stopAnimating()
            self.loadingLabel.isHidden = true
            if (self.title == nil) {
                self.title = webView.stringByEvaluatingJavaScript(from: "document.title")
            }
        }
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        if (self.activityIndicatorView.isAnimating) {
            self.activityIndicatorView.stopAnimating()
            self.loadingLabel.isHidden = true
        }
        printError(error)
        self.view.makeToast("页面无法加载，请检查网络设置")
    }
}
