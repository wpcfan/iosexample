//
//  HomeViewController.swift
//  Example
//
//  Created by 王芃 on 2018/9/30.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import Layout
import RxSwift
import RxCocoa
import RxDataSources
import RxGesture
import ReactorKit
import RxQRScanner
import URLNavigator
import CoreGraphics
import PinLayout
import Disk
import NotificationBannerSwift
import SHSegmentedControl
import NVActivityIndicatorView

class HomeViewController: BaseViewController {
    
    var segTableView:SHSegmentedControlTableView!
    var segmentControl:SHSegmentControl!
    var headerView: UIView!
    var deviceTab: DeviceTableView!
    var sceneTab: SceneTableView!
    private let navigator = container.resolve(NavigatorType.self)!
    private var refreshHeaderTrigger = PublishSubject<Void>()
    private var leftDrawerTransition: DrawerTransition?
    private var sideBarVC: SideBarViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.headerView = getHeaderView()
        //        self.segmentControl = self.getSegmentControl()
        self.segTableView = self.getSegTableView()
        self.deviceTab = DeviceTableView()
        self.sceneTab = SceneTableView()
        self.segTableView.tableViews = [deviceTab, sceneTab]
        self.view.addSubview(self.segTableView)
        buildRefreshHeader()
        setupNavigationBar()
        setupDrawer()
        reactor = HomeViewControllerReactor()
    }
    fileprivate func buildNavTopItem() {
        // Top Button
        let topButton = UIButton(type: .custom).then {
            $0.setTitle("home.nav.title".localized, for: .normal)
            $0.addTarget(self, action: #selector(HomeViewController.changeHouse), for: .touchUpInside)
            $0.sizeToFit()
        }
        self.navigationItem.titleView = topButton
    }
    func getHeaderView() -> UIView {
        if self.headerView != nil {
            return self.headerView
        }
        let header = HeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 315))
        return header
    }
    func getSegTableView() -> SHSegmentedControlTableView {
        if self.segTableView != nil {
            return self.segTableView
        }
        let segTable:SHSegmentedControlTableView = SHSegmentedControlTableView.init(frame: self.view.bounds)
        segTable.delegateCell = self
        segTable.topView = self.headerView
        //        segTable.barView = self.segmentControl
        return segTable
    }
    func getSegmentControl() -> SHSegmentControl {
        if self.segmentControl != nil {
            return self.segmentControl
        }
        let segment:SHSegmentControl = SHSegmentControl(
            frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40),
            items: ["device.tab.title".localized, "scene.tab.title".localized])
        segment.titleSelectColor = UIColor.red
        segment.reloadViews()
        weak var weakSelf = self
        segment.curClick = {(index: NSInteger) ->Void in
            // 使用?的好处 就是一旦 self 被释放，就什么也不做
            weakSelf?.segTableView.setSegmentSelect(index)
        }
        return segment
    }
    @objc func changeHouse() {
        print("enter changeHouse")
        let vc = HouseTableViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func showGroups() {
        
    }
    @objc func showMessages() {
        
    }
    fileprivate func buildRefreshHeader() {
        weak var weakSelf = self
        let refreshHeader = MJRefreshNormalHeader() {
            weakSelf?.refreshHeaderTrigger.onNext(())
        }
        self.segTableView.refreshHeader = refreshHeader
    }
    fileprivate func buildNavTopItem(title: String) {
        // Top Button
        let topButton = UIButton(type: .custom).then {
            $0.setTitle(title, for: .normal)
            $0.addTarget(self, action: #selector(HomeViewController.changeHouse), for: .touchUpInside)
            $0.sizeToFit()
        }
        self.navigationItem.titleView = topButton
        self.navigationItem.titleView?.pin.width(200)
    }
    fileprivate func buildNavLeftItem() {
        // Left Button
        let leftButton: UIButton = UIButton(type: .custom)
        leftButton.setImage(AppIcons.menu, for: .normal)
        leftButton.addTarget(self, action: #selector(toggle), for: .touchUpInside)
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: leftButton)
        
        self.navigationItem.setLeftBarButton(leftBarButtonItem, animated: false);
    }
    fileprivate func buildNavRightItems() {
        // Left Button
        let groupButton: UIButton = UIButton(type: .custom)
        groupButton.setImage(AppIcons.group, for: .normal)
        groupButton.addTarget(self, action: #selector(showGroups), for: .touchUpInside)
        let groupButtonItem: UIBarButtonItem = UIBarButtonItem(customView: groupButton)
        
        let messageButton: UIButton = UIButton(type: .custom)
        messageButton.setImage(AppIcons.message, for: .normal)
        messageButton.addTarget(self, action: #selector(showMessages), for: .touchUpInside)
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
        sideBarVC = SideBarViewController()
        leftDrawerTransition = DrawerTransition(target: self, drawer: sideBarVC)
        leftDrawerTransition?.setPresentCompletion { print("left present...") }
        leftDrawerTransition?.setDismissCompletion { print("left dismiss...") }
        leftDrawerTransition?.edgeType = .left
        leftDrawerTransition?.drawerWidth = UIScreen.main.bounds.width * 0.7
    }
}

extension HomeViewController: ReactorKit.StoryboardView {
    typealias Reactor = HomeViewControllerReactor
    
    func bind(reactor: Reactor) {
        
        reactor.action.onNext(.reportPushRegId)
        
        CURRENT_HOUSE
            .startWith(nil)
            .mapTo(Reactor.Action.load)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // Handle Logout Globally
        NEED_LOGOUT
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.asyncInstance)
            .subscribe{ _ in
                AppDelegate.shared.rootViewController.switchToLogout()
            }
            .disposed(by: self.disposeBag)
        
        NEED_REBIND
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.asyncInstance)
            .subscribe{ _ in
                AppDelegate.shared.rootViewController.switchToBindJdAccount()
            }
            .disposed(by: self.disposeBag)
        
        deviceTab.rx.addDeviceTapped
            .flatMapLatest { (_) -> Observable<String?> in
                RxQRUtil().scanQR(self)
            }
            .subscribe{
                print($0)
            }
            .disposed(by: self.disposeBag)
        
        sceneTab.rx.addSceneTapped
            .subscribe { ev in
                print("add scene")
            }
            .disposed(by: disposeBag)
        
        Observable.merge(
            (self.headerView as! HeaderView).bannerTapped,
            (self.headerView as! HeaderView).channelTapped)
            .subscribe { ev in
                guard let url = ev.element else { return }
                self.navigator.push(WebKitViewController(url: url), from: self.navigationController, animated: true)
            }
            .disposed(by: disposeBag)
        
        refreshHeaderTrigger
            .mapTo(Reactor.Action.refresh)
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.homeInfo?.banners ?? [] }
            .bind(to: (self.headerView as! HeaderView).banners$)
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.homeInfo?.channels ?? [] }
            .bind(to: (self.headerView as! HeaderView).channels$)
            .disposed(by: self.disposeBag)
        
        reactor.state   
            .map { $0.homeInfo?.devices ?? [] }
            .bind(to: self.deviceTab.devices$)
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.loading }
            .distinctUntilChanged()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.asyncInstance)
            .subscribe{ ev in
                guard let loading = ev.element, !self.segTableView.refreshHeader.isRefreshing else {
                    return
                }
                let animating = NVActivityIndicatorPresenter.sharedInstance.isAnimating
                if loading && !animating {
                    let activityData = ActivityData(message: "indicator.loading".localized)
                    NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
                } else {
                    if (animating) {
                        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                    }
                }
            }
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.homeInfo }
            .filterNil()
            .subscribe{ ev in
                guard let home = ev.element else { return }
                let button = self.navigationItem.titleView as! UIButton
                let title = home.house?.displayName() ?? ""
                let isOwner = home.house?.isOwner ?? false
                self.deviceTab.sectionHeaderView.rightBtnHidden = !isOwner
                self.sceneTab.sectionHeaderView.rightBtnHidden = !isOwner
                button.setTitle(title.trunc(length: 14), for: .normal)
                if (self.segTableView.refreshHeader.isRefreshing) {
                    self.segTableView.refreshHeader.endRefreshing()
                }
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
}

extension HomeViewController: SHSegTableViewDelegate {
    func segTableViewDidScrollY(_ offsetY: CGFloat) {
        
    }
    func segTableViewDidScroll(_ tableView: UIScrollView!) {
        
    }
    func segTableViewDidScrollSub(_ subTableView: UIScrollView!) {
        
    }
    func segTableViewDidScrollProgress(_ progress: CGFloat, originalIndex: Int, targetIndex: Int) {
        if progress == 1 {
            //            self.segmentControl.setSegmentSelectedIndex(targetIndex)
        }
    }
}

extension HomeViewController: DrawerTransitionDelegate {
    @objc func toggle()  {
        self.leftDrawerTransition?.presentDrawerViewController(animated: true)
    }
}