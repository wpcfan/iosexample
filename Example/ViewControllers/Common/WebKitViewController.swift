//
//  WebKitViewController.swift
//  Example
//
//  Created by 王芃 on 2019/2/17.
//  Copyright © 2019 twigcodes. All rights reserved.
//
import URLNavigator
import WebKit
import RxWebKit
import RxSwift
import Layout
import NVActivityIndicatorView

class WebKitViewController: BaseViewController, LayoutLoading {
    @objc weak var webView: WKWebView!
    @objc weak var activityIndicatorView: NVActivityIndicatorView!
    @objc weak var loadingLabel: UILabel!
    var url: URLConvertible
    var pageTitle: String?
    
    // MARK: Initializing
    init(url: URLConvertible, pageTitle: String = "") {
        self.url = url
        self.pageTitle = pageTitle
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLayout(named: "WebKitViewController.xml")
    }
    
    func layoutDidLoad(_: LayoutNode) {
        webView.load(url)
        weak var `self`: WebKitViewController! = self
        webView.rx.url
            .share(replay: 1)
            .subscribe{ ev in
                if (!self.activityIndicatorView.isAnimating) {
                    self.activityIndicatorView.startAnimating()
                    self.loadingLabel.isHidden = false
                }
            }
            .disposed(by: disposeBag)
        
        webView.rx.estimatedProgress
            .share(replay: 1)
            .subscribe{ ev in
                guard let progress = ev.element else { return }
                if (progress.isEqual(to: 1.0)) {
                    if (self.activityIndicatorView.isAnimating) {
                        self.activityIndicatorView.stopAnimating()
                        self.loadingLabel.isHidden = true
                    }
                }
            }
            .disposed(by: disposeBag)
        
        webView.rx.title
            .share(replay: 1)
            .subscribe{ ev in
                guard let title = ev.element else { return }
                self.title = self.pageTitle.isBlank ? title : self.pageTitle
            }
            .disposed(by: disposeBag)
    }
}
