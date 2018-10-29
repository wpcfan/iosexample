//
//  Splash.swift
//  Example
//
//  Created by 王芃 on 2018/10/5.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import UIKit
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
            .takeWhile { val -> Bool in val >= 0 }
        countDownStream
            .filter { (count) -> Bool in  count == 0 }
            .map{ _ in Reactor.Action.navigateTo }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        countDown.rx.tap
            .withLatestFrom(reactor.state)
            .map{ _ in Reactor.Action.navigateTo }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        countDownStream
            .map { _ in Reactor.Action.tick }
            .takeUntil(reactor.action.filter {
                if case .navigateTo = $0 {
                    return true
                } else {
                    return false
                }
            })
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        reactor.state
            .map { $0.countDown }
            .distinctUntilChanged()
            .bind(to: self.layoutNode!.rx.state("countDownTitle"))
            .disposed(by: self.disposeBag)
        reactor.state
            .debug()
            .map { $0.tourPresented }
            .distinctUntilChanged()
            .filter{ (status) -> Bool in status }
            .map{ _ in Reactor.Action.checkAuth }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }
}
