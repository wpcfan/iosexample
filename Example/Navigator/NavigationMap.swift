//
//  NavigationMap.swift
//  URLNavigatorExample
//
//  Created by Suyeol Jeon on 7/12/16.
//  Copyright © 2016 Suyeol Jeon. All rights reserved.
//
import SafariServices
import UIKit
import PMAlertController
import URLNavigator
import RxQRScanner
import WebKit
import RxWebKit
import RxSwift
import NVActivityIndicatorView
import PinLayout

enum NavigationMap {
    static func initialize(navigator: NavigatorType) {
        navigator.register("\(Constants.NAVI_PREFIX)://home") { url, values, context in
            let viewController = HomeViewController()
            return viewController;
        }
        navigator.register("\(Constants.NAVI_PREFIX)://home/myhouses") { url, values, context in
            let viewController = HouseTableViewController()
            return viewController;
        }
        navigator.register("\(Constants.NAVI_PREFIX)://me/settings") { url, values, context in
            let viewController = SettingViewController()
            return viewController;
        }
        
        navigator.register("http://<path:_>", self.webViewControllerFactory)
        navigator.register("https://<path:_>", self.webViewControllerFactory)
        
        navigator.handle("\(Constants.NAVI_PREFIX)://alert", self.alert(navigator: navigator))
        navigator.handle("\(Constants.NAVI_PREFIX)://pmalert", self.pmAlert(navigator: navigator))
        navigator.handle("\(Constants.NAVI_PREFIX)://<path:_>") { (url, values, context) -> Bool in
            // No navigator match, do analytics or fallback function here
            print("[Navigator] NavigationMap.\(#function):\(#line) - global fallback function is called")
            return true
        }
    }
    
    private static func webViewControllerFactory(
        url: URLConvertible,
        values: [String: Any],
        context: Any?
        ) -> UIViewController? {
        guard let url = url.urlValue else { return nil }
//        let webVC = SafariWebViewController(url: url, entersReaderIfAvailable: false)
        guard let pageTitle = values["title"] as? String else { return WebKitViewController(url: url) }
        let webVC = WebKitViewController(url: url, pageTitle: pageTitle)
        return webVC
    }
    
    private static func alert(navigator: NavigatorType) -> URLOpenHandlerFactory {
        return { url, values, context in
            guard let title = url.queryParameters["title"] else { return false }
            let message = url.queryParameters["message"]
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(
                title:"pmalert.ok.title".localized,
                style: .default,
                handler: nil))
            navigator.present(alertController)
            return true
        }
    }
    
    private static func pmAlert(navigator: NavigatorType) -> URLOpenHandlerFactory {
        return { url, values, context in
            guard let title = url.queryParameters["title"] else { return false }
            let message = url.queryParameters["message"]
            let alertVC = PMAlertController(title: title, description: message ?? "", image: AppIcons.sceneHomeAccent, style: .alert)
            
            alertVC.addAction(PMAlertAction(
                title: "pmalert.cancel.title".localized,
                style: .cancel,
                action: { () -> Void in
                    print("Capture action Cancel")
                }))
            
            alertVC.addAction(PMAlertAction(
                title:"pmalert.ok.title".localized,
                style: .default,
                action: { () in
                    print("Capture action OK")
                }))
            
            navigator.present(alertVC)
            return true
        }
    }
}

class SafariWebViewController: SFSafariViewController {
    override init(url URL: URL, entersReaderIfAvailable: Bool) {
        super.init(url: URL, entersReaderIfAvailable: entersReaderIfAvailable)
        delegate = self
        
        if #available(iOS 10.0, *) {
            preferredBarTintColor = .primary
            preferredControlTintColor = .white
        }
    }
}

extension SafariWebViewController: SFSafariViewControllerDelegate {
    internal func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true)
    }
}

class WebKitViewController: UIViewController {
    let webView = WKWebView()
    var url: URLConvertible
    var disposeBag = DisposeBag()
    var pageTitle: String?
    
    // MARK: Initializing
    init(url: URLConvertible, pageTitle: String = "") {
        self.url = url
        self.pageTitle = pageTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        self.view.addSubview(webView)
        let `self`: WebKitViewController! = self
        webView.pin.all()
        webView.load(url)
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
