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
import RxSwift
import RxCocoa
import ReactorKit

class TourViewController: BaseViewController {
    
    private let imageNames = ["Tour_1","Tour_2"]
    private var introView: EAIntroView?
    private var tourCompleted = PublishSubject<Void>()
}

extension TourViewController: EAIntroDelegate {
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
        tourCompleted.onNext(())
    }
}

extension TourViewController: LayoutLoading {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.loadLayout(named: "TourViewController.xml" )
        preparePages()
    }
    
    func layoutDidLoad(_: LayoutNode) {
        self.reactor = TourViewControllerReactor()
    }
}

extension TourViewController: ReactorKit.View {
    typealias Reactor = TourViewControllerReactor
    
    func bind(reactor: Reactor) {
        
        reactor.action.onNext(.checkAuth)
        tourCompleted.asObservable()
            .map { _ in Reactor.Action.setFirstLaunch }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        tourCompleted.asObservable()
            .withLatestFrom(reactor.state)
            .map{ _ in Reactor.Action.navigateTo }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
    }
}
