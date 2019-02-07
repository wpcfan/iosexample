//
//  MainViewController.swift
//  Example
//
//  Created by 王芃 on 2019/1/31.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import RxSwift
import ReactorKit
import NotificationBannerSwift
import Layout
import URLNavigator
import PinLayout
import RxOptional
import SafariServices

class MainViewController: ScrollingStackController, StoryboardView {
    
    private let navigator = container.resolve(NavigatorType.self)!
    private var refreshHeaderTrigger = PublishSubject<Void>()
    private var leftDrawerTransition: DrawerTransition?
    private var leftMenu: UIViewController?
    
    typealias Reactor = HomeViewControllerReactor
    
    // MARK: Rx
    var disposeBag = DisposeBag()
    let bannerVC = HomeBannerViewController()
    let channelVC = HomeChannelViewController()
    let tabPaneVC = HomePageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    let pageControl = UIPageControl().then {
        $0.currentPageIndicatorTintColor = .darkGray
        $0.pageIndicatorTintColor = .lightGray
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView = UIScrollView()
        self.view = self.scrollView!
        self.view.backgroundColor = .white
        self.reload()
        setupNavigationBar()
        let refreshHeader = PullToRefreshUtil.createHeader()
        scrollView?.configRefreshHeader(with: refreshHeader, container:self) { [weak self] in
            self!.refreshHeaderTrigger.onNext(())
        }
        setupDrawer()
        setupPageControl()
        reactor = HomeViewControllerReactor()
    }
    
    func reload() {
        self.viewControllers = [bannerVC, channelVC, tabPaneVC]
    }
    
    func bind(reactor: Reactor) {
        
        reactor.action.onNext(.load)
        
        bannerVC.bannerTapped.subscribe { ev in
            guard let url = ev.element else { return }
            self.navigator.push(WebKitViewController(url: url), from: self.navigationController, animated: true)
        }
        .disposed(by: disposeBag)
        
        tabPaneVC.rx.pageSwitched
            .subscribe { _ in
                self.reconnect(with: self.tabPaneVC)
            }
            .disposed(by: disposeBag)
        
        refreshHeaderTrigger
            .mapTo(Reactor.Action.load)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.homeInfo?.banners ?? [] }
            .bind(to: self.bannerVC.banners$)
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.homeInfo?.channels ?? [] }
            .bind(to: self.channelVC.channels$)
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.homeInfo?.devices ?? [] }
            .bind(to: self.tabPaneVC.vc1.devices$)
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.homeInfo }
            .filterNil()
            .subscribe{ ev in
                guard let home = ev.element else { return }
                let button = self.navigationItem.titleView as! UIButton
                let title = home.house?.displayName() ?? ""
                button.setTitle(title.trunc(length: 14), for: .normal)
                self.scrollView?.switchRefreshHeader(to: .normal(.success, 0.3))
            }
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.errorMessage }
            .filter({ (msg) -> Bool in !msg.isBlank })
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.asyncInstance)
            .subscribe{ ev in
                guard let err = ev.element else { return }
                let banner = NotificationBanner(title: "错误", subtitle: err, style: .warning)
                banner.show()
            }
            .disposed(by: self.disposeBag)
    }
    
    @objc func changeHouse() {
        print("enter changeHouse")
        let vc = HouseTableViewController()
        navigator.push(vc, from: self.navigationController, animated: true)
    }
    
    @objc func showGroups() {
        
    }
    
    @objc func showMessages() {
        
    }
    
    fileprivate func buildNavTopItem(title: String) {
        // Top Button
        let topButton = UIButton(type: .custom).then {
            $0.setTitle(title, for: .normal)
            $0.addTarget(self, action: #selector(MainViewController.changeHouse), for: .touchUpInside)
            $0.sizeToFit()
        }
        self.navigationItem.titleView = topButton
        self.navigationItem.titleView?.pin.width(200)
    }
    
    fileprivate func buildNavLeftItem() {
        // Left Button
        let leftButton: UIButton = UIButton(type: .custom)
        leftButton.setImage(AppIcons.menu, for: .normal)
        leftButton.addTarget(self, action: #selector(MainViewController.toggle), for: .touchUpInside)
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: leftButton)
        
        self.navigationItem.setLeftBarButton(leftBarButtonItem, animated: false);
    }
    
    fileprivate func buildNavRightItems() {
        // Left Button
        let groupButton: UIButton = UIButton(type: .custom)
        groupButton.setImage(AppIcons.group, for: .normal)
        groupButton.addTarget(self, action: #selector(MainViewController.showGroups), for: .touchUpInside)
        let groupButtonItem: UIBarButtonItem = UIBarButtonItem(customView: groupButton)
        
        let messageButton: UIButton = UIButton(type: .custom)
        messageButton.setImage(AppIcons.message, for: .normal)
        messageButton.addTarget(self, action: #selector(MainViewController.showMessages), for: .touchUpInside)
        let messageButtonItem: UIBarButtonItem = UIBarButtonItem(customView: messageButton)
        
        self.navigationItem.setRightBarButtonItems([messageButtonItem, groupButtonItem], animated: false)
    }
    
    fileprivate func setupNavigationBar() {
        self.navigationController?.presentDarkNavigationBar(UIColor.primary, UIColor.textIcon)
        buildNavTopItem(title: "首页")
        buildNavLeftItem()
        buildNavRightItems()
    }
    
    fileprivate func setupDrawer() {
        leftMenu = SideBarViewController()
        leftDrawerTransition = DrawerTransition(target: self, drawer: leftMenu)
        leftDrawerTransition?.setPresentCompletion { print("left present...") }
        leftDrawerTransition?.setDismissCompletion { print("left dismiss...") }
        leftDrawerTransition?.edgeType = .left
    }
    
    fileprivate func setupPageControl() {
        pageControl.numberOfPages = self.tabPaneVC.pages.count
        pageControl.currentPage = self.tabPaneVC.currentIndex
        self.view.addSubview(pageControl)
    }
}

extension MainViewController: DrawerTransitionDelegate {
    @objc func toggle()  {
        self.leftDrawerTransition?.presentDrawerViewController(animated: true)
    }
}
