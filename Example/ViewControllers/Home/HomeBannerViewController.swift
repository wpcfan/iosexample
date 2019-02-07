//
//  HomeBannerViewController.swift
//  Example
//
//  Created by 王芃 on 2018/11/28.
//  Copyright © 2018 twigcodes. All rights reserved.
//
import Layout
import ReactorKit
import RxSwift

class HomeBannerViewController: BaseViewController, StackContainable {
    @objc weak var bannerView: BannerView!
    var banners$ = BehaviorSubject<[Banner]>(value: [])
    var bannerTapped = PublishSubject<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        loadLayout(named: "HomeBannerViewController.xml")
    }
    
    public func preferredAppearanceInStack() -> ScrollingStackController.ItemAppearance {
        return .view(height: 135)
    }
}

extension HomeBannerViewController: LayoutLoading {
    func layoutDidLoad(_: LayoutNode) {
        
        self.banners$.subscribe{ ev in
            guard let banners = ev.element else { return }
            self.bannerView.banners = banners
        }
        .disposed(by: self.disposeBag)
        
        self.bannerView.rx.bannerImageTap
            .bind(to: self.bannerTapped)
            .disposed(by: self.disposeBag)
    }
}
