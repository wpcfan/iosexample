//
//  BaseViewController.swift
//  Example
//
//  Created by 王芃 on 2018/10/17.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import UIKit

import RxSwift
import Reachability
import RxReachability
import NotificationBannerSwift
import NVActivityIndicatorView

class BaseViewController: UIViewController {
    // MARK: Rx
    // has to be var as the need to conform the Reactor.View protocol
    var disposeBag = DisposeBag()
    
    // MARK: Initializing
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.setNeedsUpdateConstraints()
        bindReachability()
    }
    
    func initialize() -> Void {
        
    }
    
    func bindReachability() {
        Reachability.rx.reachabilityChanged
            .subscribe(onNext: { (reachability: Reachability) in
                reachability.whenUnreachable = { _ in
                    let notificationBanner = NotificationBanner(title: "网络故障", subtitle: "网络好像断掉了，请检查网络设置", style: .warning)
                    notificationBanner.show()
                }
                reachability.whenReachable = { _ in
                    let notificationBanner = NotificationBanner(title: "网络恢复", subtitle: "网络连接恢复正常", style: .success)
                    notificationBanner.show()
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    func toggleLoading(_ loading: Bool) {
        let animating = NVActivityIndicatorPresenter.sharedInstance.isAnimating
        if loading && !animating {
            let activityData = ActivityData(message: "indicator.loading".localized)
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
        } else {
            if (animating) {
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            }
        }
    }
}
