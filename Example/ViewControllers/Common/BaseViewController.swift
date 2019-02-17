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
import SwiftEntryKit
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
                    self.buildNotificationBanner("网络故障", "网络好像断掉了，请检查网络设置", .warn)
                }
                reachability.whenReachable = { _ in
                    self.buildNotificationBanner("网络恢复", "网络连接恢复正常", .info)
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
    
    func buildNotificationBanner(_ title: String, _ desc: String, _ type: NotificationType = .info, _ titleColor: UIColor = .white, _ descColor: UIColor = .white) -> Void {
        var attributes = EKAttributes.topToast
//        attributes.entryBackground = .gradient(gradient: .init(colors: [.red, .green], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
        attributes.statusBar = .dark
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
        
        let title = EKProperty.LabelContent(text: title, style: .init(font: .systemFont(ofSize: 16), color: titleColor))
        let description = EKProperty.LabelContent(text: desc, style: .init(font: .systemFont(ofSize: 14), color: descColor))
        var image: EKProperty.ImageContent
        switch type {
        case .info:
            attributes.entryBackground = .color(color: .primary)
            image = EKProperty.ImageContent(image: AppIcons.info, size: CGSize(width: 35, height: 35))
        case .warn:
            attributes.entryBackground = .color(color: .orange)
            image = EKProperty.ImageContent(image: AppIcons.warn, size: CGSize(width: 35, height: 35))
        case .error:
            attributes.entryBackground = .color(color: .red)
            image = EKProperty.ImageContent(image: AppIcons.error, size: CGSize(width: 35, height: 35))
        }
        let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
        let contentView = EKNotificationMessageView(with: notificationMessage)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
}

public enum NotificationType {
    case info
    case warn
    case error
}
