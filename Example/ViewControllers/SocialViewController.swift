//
//  SocialViewController.swift
//  Example
//
//  Created by 王芃 on 2018/10/1.
//  Copyright © 2018年 twigcodes. All rights reserved.
//
import RxSwift

class SocialViewController: ScrollingStackController {
    
    // MARK: Rx
    var disposeBag = DisposeBag()
    let bannerVC = HomeBannerViewController()
    let tabPaneVC = HomePageViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView = UIScrollView()
        self.view = self.scrollView!
        self.reload()
        tabPaneVC.rx.pageSwitched
            .subscribe { _ in
                self.reconnect(with: self.tabPaneVC)
            }
            .disposed(by: disposeBag)
    }
    
    func reload() {
        self.viewControllers = [bannerVC, tabPaneVC]
    }
}
