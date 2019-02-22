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
            .subscribe{ [weak self] ev in
                guard let _self = self else { return }
                if (!_self.activityIndicatorView.isAnimating) {
                    _self.activityIndicatorView.startAnimating()
                    _self.loadingLabel.isHidden = false
                }
            }
            .disposed(by: disposeBag)
        
        webView.rx.estimatedProgress
            .share(replay: 1)
            .subscribe{ [weak self] ev in
                guard let _self = self, let progress = ev.element else { return }
                if (progress.isEqual(to: 1.0)) {
                    if (_self.activityIndicatorView.isAnimating) {
                        _self.activityIndicatorView.stopAnimating()
                        _self.loadingLabel.isHidden = true
                    }
                }
            }
            .disposed(by: disposeBag)
        
        webView.rx.title
            .share(replay: 1)
            .subscribe{ [weak self] ev in
                guard let title = ev.element, let _self = self else { return }
                _self.title = _self.pageTitle.isBlank ? title : _self.pageTitle
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

extension NVActivityIndicatorView {
    public override class var parameterTypes: [String: RuntimeType] {
        return [
            "type": RuntimeType(NVActivityIndicatorType.self),
            "color": RuntimeType(UIColor.self),
            "padding": RuntimeType(CGFloat.self),
        ]
    }
    
    public override class func create(with node: LayoutNode) throws -> NVActivityIndicatorView {
        if let type = try node.value(forExpression: "type") as? NVActivityIndicatorType,
            let color = try node.value(forExpression: "color") as? UIColor,
            let padding = try node.value(forExpression: "padding") as? CGFloat {
            return self.init(frame: .zero, type: type, color: color, padding: padding)
        }
        return self.init(frame: .zero)
    }
}
