//
//  Splash.swift
//  Example
//
//  Created by 王芃 on 2018/10/5.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import Layout
import pop
import RxSwift
import Shallows
import ReactorKit

class SplashViewController: BaseViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var countDown: UIButton!

    var layer: CALayer {
        return imageView.layer
    }
    
    func setUpLayer() {
        if let anim = POPSpringAnimation(propertyNamed: kPOPLayerBounds) {
            anim.toValue = NSValue(cgRect: CGRect(x: 0, y: 0, width: 200, height: 200))
            layer.pop_add(anim, forKey: "size")
        }
    }
}

extension SplashViewController: LayoutLoading {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadLayout(
            named: "SplashViewController.xml",
            state: ["countDownTitle": 5])
    }
    
    func layoutDidLoad(_: LayoutNode) {
        setUpLayer()
        self.reactor = SplashViewControllerReactor()
    }
}

extension SplashViewController: ReactorKit.View {
    typealias Reactor = SplashViewControllerReactor
    
    func bind(reactor: Reactor) {
        
        reactor.action.onNext(.checkFirstLaunch)
        
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
