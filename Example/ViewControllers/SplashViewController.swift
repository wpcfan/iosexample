//
//  Splash.swift
//  Example
//
//  Created by 王芃 on 2018/10/5.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import Layout
import RxSwift
import Shallows
import ReactorKit

class SplashViewController: BaseViewController {
    
    @objc weak var imageView: UIImageView? {
        didSet {
            guard let imageView = imageView else { return }
            imageView.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            
            UIView.animate(withDuration: 5.0,
                           delay: 0,
                           usingSpringWithDamping: CGFloat(0.20),
                           initialSpringVelocity: CGFloat(6.0),
                           options: UIView.AnimationOptions.allowUserInteraction,
                           animations: { imageView.transform = CGAffineTransform.identity },
                           completion: { Void in() }
            )
        }
    }
    @objc weak var countDown: UIButton!
}

extension SplashViewController: LayoutLoading {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadLayout(
            named: "SplashViewController.xml",
            state: ["countDownTitle": 5])
    }
    
    func layoutDidLoad(_: LayoutNode) {
        self.reactor = SplashViewControllerReactor()
    }
}

extension SplashViewController: ReactorKit.View {
    typealias Reactor = SplashViewControllerReactor
    
    func bind(reactor: Reactor) {
        
        reactor.action.onNext(.checkFirstLaunch)
        reactor.action.onNext(.checkRegister)
        
        let countDownStream =  Observable<Int>
            .interval(1, scheduler: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .map { val -> Int in 5 - val }
            .takeWhile { val -> Bool in val > 0 }
        
        Observable.merge(
            countDown.rx.tap.map { _ in 0 },
            countDownStream.filter { (count) -> Bool in  count == 1 })
            .withLatestFrom(reactor.state)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.asyncInstance)
            .subscribe { ev in
                switch ev.element!.nav {
                case .login:
                    AppDelegate.shared.rootViewController.showLoginScreen()
                case .main:
                    AppDelegate.shared.rootViewController.switchToMainScreen()
                case .tour:
                    AppDelegate.shared.rootViewController.switchToTour()
                }
            }
            .disposed(by: self.disposeBag)
        
        countDownStream
            .map { _ in Reactor.Action.tick }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.countDown }
            .distinctUntilChanged()
            .bind(to: self.layoutNode!.rx.state("countDownTitle"))
            .disposed(by: self.disposeBag)
    }
}
