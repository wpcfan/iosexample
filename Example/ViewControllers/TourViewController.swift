//
//  TourViewController.swift
//  Example
//
//  Created by 王芃 on 2018/10/7.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import Layout
import RxSwift
import RxCocoa
import ReactorKit

class TourViewController: BaseViewController {
    
    private let totalPages = 3
    private var tourCompleted = PublishSubject<Void>();
    @objc var scrollView: UIScrollView?
    @objc var pageControl: UIPageControl?
    @objc var lastPage: Bool = false {
        didSet {
            layoutNode?.setState(["lastPage": lastPage])
        }
    }
    @objc func skipOrFinish() {
        tourCompleted.onNext(())
    }
}

extension TourViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView === self.scrollView {
            let offsetRatio = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
            let index = abs(offsetRatio) % totalPages
            lastPage = index == totalPages - 1
            if (offsetRatio >= totalPages) {
                pageControl?.currentPage = totalPages - 1
                skipOrFinish()
                return
            }
            if (index < 0) {
                pageControl?.currentPage = 0
                return
            }
            pageControl?.currentPage = index
        }
    }
}

extension TourViewController: LayoutLoading {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadLayout(named: "TourViewController.xml",
                        state: ["Tour_1": UIImage(named: "Tour_1")!,
                                "Tour_2": UIImage(named: "Tour_2")!,
                                "Tour_3": UIImage(named: "Tour_3")!,
                                "totalPages": totalPages,
                                "lastPage": lastPage])
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
            .map { _ in Reactor.Action.completeTour }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state
            .filter { $0.tourGuidePresented }
            .distinctUntilChanged { $0.tourGuidePresented }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.asyncInstance)
            .subscribe { ev in
                switch ev.element!.nav {
                case .login:
                    AppDelegate.shared.rootViewController.showLoginScreen()
                case .main:
                    AppDelegate.shared.rootViewController.switchToHome()
                }
            }
            .disposed(by: self.disposeBag)
    }
}
