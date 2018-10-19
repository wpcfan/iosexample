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

class SplashViewController: BaseViewController, LayoutLoading {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var countDown: UIButton!
    private let completeCountDownSubject = PublishSubject<Void>()
    private let storage = container.resolve(Storage<Filename, AppData>.self)!
    private let oauth2Service = container.resolve(OAuth2Service.self)!
    
    var layer: CALayer {
        return imageView.layer
    }
    
    func setUpLayer() {
        if let anim = POPSpringAnimation(propertyNamed: kPOPLayerBounds) {
            anim.toValue = NSValue(cgRect: CGRect(x: 0, y: 0, width: 200, height: 200))
            layer.pop_add(anim, forKey: "size")
        }
    }
    
    fileprivate func authStream() -> Observable<Bool> {
        return tourGuidePresentedStream()
            .filter { (val) -> Bool in
                log.debug("tourGuidePresented: " + String(val))
                return val
            }
            .flatMap { (_) -> Observable<Bool> in
                return Observable.of(self.oauth2Service.checkLoginStatus())
            }
    }
    
    fileprivate func tourGuidePresentedStream() -> Observable<Bool> {
        return stopCountDownStream().flatMap { (_) -> Observable<Bool> in
            self.storage
                .rx_retrieve(forKey: "data")
                .map{ (val) -> Bool in
                    let result = val as? AppData
                    return result?.tourGuidePresented ?? false
                }
                .catchError({ (error) -> Observable<Bool> in
                    Observable.of(false)
                })
                .take(1)
            }
    }
    
    fileprivate func countDownStream() -> Observable<Int> {
        return Observable<Int>
            .interval(1, scheduler: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .map { val -> Int in 5 - val }
    }
    
    fileprivate func stopCountDownStream() -> Observable<Bool> {
        return Observable<Bool>
            .merge([
                countDownStream()
                    .map{ (val) -> Bool in val <= 0 }
                    .filter{ (val) -> Bool in val == true },
                self.completeCountDownSubject.asObservable().map{ _ in
                    return true
                }])
            .take(1)
    }
    
    fileprivate func countDownForConditionStream() -> Observable<String> {
        return countDownStream()
            .map{ (val) -> String in
                String(val)
            }
            .takeUntil(stopCountDownStream())
    }
    
    fileprivate func updateCountDownTick() -> Void {
        countDownForConditionStream()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.instance)
            .subscribe{ event -> Void in
                switch event {
                case .error(let error):
                    log.error(error.localizedDescription)
                    break
                case .next(let label):
                    self.countDown.setTitle(label, for: .normal)
                    break
                case .completed:
                    break
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    fileprivate func checkAndNavigateToTourView() -> Void {
        tourGuidePresentedStream()
            .filter({ (val) -> Bool in
                !val
            })
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.instance)
            .subscribe{ event -> Void in
                switch event {
                case .error(let error):
                    log.error(error.localizedDescription)
                    break
                case .next(_):
                    log.info("will switch to Tour Screen soon")
                    AppDelegate.shared.rootViewController.switchToTour()
                    break
                case .completed:
                    break
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    fileprivate func checkAndNavigateToLogin() {
        authStream()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.asyncInstance)
            .subscribe{ event -> Void in
                switch event {
                case .error(let error):
                    log.error(error.localizedDescription)
                    AppDelegate.shared.rootViewController.showLoginScreen()
                    break
                case .next(let result):
                    if (result) {
                        AppDelegate.shared.rootViewController.switchToMainScreen()
                    } else {
                        AppDelegate.shared.rootViewController.showLoginScreen()
                    }
                    break
                case .completed:
                    break
                }
            }
            .disposed(by: self.disposeBag)
    }
    
    @IBAction func completeCountDown() {
        self.completeCountDownSubject.onNext(())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadLayout(named: "SplashViewController.xml" )
        setUpLayer()
        updateCountDownTick()
        checkAndNavigateToTourView()
        checkAndNavigateToLogin()
    }
}
