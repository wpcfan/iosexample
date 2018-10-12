//
//  TourViewController.swift
//  Example
//
//  Created by 王芃 on 2018/10/7.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import UIKit
import Layout
import EAIntroView
import Shallows
import RxSwift
import RxCocoa

class TourViewController: UIViewController, LayoutLoading, EAIntroDelegate {
    
    fileprivate let imageNames = ["Tour_1","Tour_2"]
    private var introView: EAIntroView?
    private var disposeBag = DisposeBag()
    private let storage = container.resolve(Storage<Filename, AppData>.self)!
    private let oauth2Service = container.resolve(OAuth2Service.self)!
    
    func preparePages() -> Void {
        let page1 = EAIntroPage()
        page1.title = "Hello"
        page1.desc = "This is first page"
        page1.bgImage = UIImage(named: "Tour_1")
        let page2 = EAIntroPage()
        page2.title = "Again"
        page2.desc = "This is second page"
        page2.bgImage = UIImage(named: "Tour_2")
        self.introView = EAIntroView.init(frame: self.view.bounds, andPages: [page1, page2])
        self.introView?.skipButton.setTitle("Main", for: .normal)
        self.introView?.delegate = self
        self.introView?.show(in: self.view, animateDuration: 0.2)
    }
    
    func introDidFinish(_ introView: EAIntroView!, wasSkipped: Bool) {
        self.storage
            .rx_set(value: AppData(tourGuidePresented: true), forKey: "data")
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.instance)
            .subscribe{ event -> Void in
                switch event {
                case .error(let error):
                    log.error(error.localizedDescription)
                    break
                case .next(let result):
                    log.debug(result)
                    break
                case .completed:
                    break
                }
            }
            .disposed(by: self.disposeBag)
        
        let auth$ = Observable.of(oauth2Service.checkLoginStatus())
        
        auth$.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.instance)
            .subscribe{ event -> Void in
                switch event {
                case .error(let error):
                    log.error(error.localizedDescription)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.loadLayout(named: "TourViewController.xml" )
        preparePages()
    }
}
