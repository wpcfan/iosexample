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
            .subscribe(onNext: {
                print("URL: \(String(describing: $0))")
                if (!NVActivityIndicatorPresenter.sharedInstance.isAnimating) {
                    let activityData = ActivityData(message: "indicator.loading".localized)
                    NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
                }
            })
            .disposed(by: disposeBag)
        
        webView.rx.estimatedProgress
            .share(replay: 1)
            .timeout(10, scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                if ($0.isEqual(to: 1.0)) {
                    if (NVActivityIndicatorPresenter.sharedInstance.isAnimating) {
                        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        webView.rx.title
            .subscribe{ ev in
                guard let title = ev.element else { return }
                self.title = self.pageTitle.isBlank ? title : self.pageTitle
            }
            .disposed(by: disposeBag)
        
        initialize()
    }
}

extension WKWebView {
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
    
    func load(_ urlString: URLConvertible) {
        if let url = urlString.urlValue {
            let request = URLRequest(url: url)
            load(request)
        }
    }
}
