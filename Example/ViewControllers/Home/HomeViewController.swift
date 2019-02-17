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
    weak var segTableView: SHSegmentedControlTableView!
    weak var segmentControl: SHSegmentControl!
    weak var headerView: UIView!
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
        let header = HeaderView()
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
        weak var `self`: HomeViewController! = self
        sideBarVC = SideBarViewController()
        leftDrawerTransition = DrawerTransition(target: self, drawer: sideBarVC)
        leftDrawerTransition?.setPresentCompletion { print("left present...") }
        leftDrawerTransition?.setDismissCompletion { print("left dismiss...") }
        leftDrawerTransition?.edgeType = .left
        leftDrawerTransition?.drawerWidth = UIScreen.main.bounds.width * 0.7
    }
}

extension HomeViewController: ReactorKit.View {
    typealias Reactor = HomeViewControllerReactor
    
    func bind(reactor: Reactor) {
        
        reactor.action.onNext(.reportPushRegId)
        weak var `self`: HomeViewController! = self
        weak var headerView: HeaderView! = (self.headerView as! HeaderView)
        
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
            .disposed(by: disposeBag)
        
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
            .disposed(by: disposeBag)
        
        deviceTab.rx.rebind
            .subscribe { ev in
                guard let device = ev.element else { return }
                
            }
            .disposed(by: disposeBag)
        
        deviceTab.rx.deviceSelected
            .subscribe { ev in
                guard let device = ev.element else { return }
                
            }
            .disposed(by: disposeBag)
        
        sceneTab.rx.addSceneTapped
            .subscribe { ev in
                print("add scene")
            }
            .disposed(by: disposeBag)
        
        Observable.merge(
            headerView.bannerTapped,
            headerView.channelTapped)
            .subscribe { [weak self] ev in
                guard let url = ev.element, let _self = self else { return }
                _self.navigator.push(WebKitViewController(url: url), from: _self.navigationController, animated: true)
            }
            .disposed(by: disposeBag)
        
        refreshHeaderTrigger
            .mapTo(Reactor.Action.refresh)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.homeInfo }
            .filterNil()
            .bind(to: headerView.homeInfo$)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.indoorEnvSnapShot }
            .filterNil()
            .bind(to: headerView.indoor$)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.homeInfo?.devices ?? [] }
            .bind(to: deviceTab.devices$)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.indoorEnvSnapShot != nil }
            .distinctUntilChanged()
            .subscribe{ [weak self] ev in
                guard let displayAir = ev.element, let _self = self else { return }
                headerView.displayAir$.onNext(displayAir)
                headerView.frame = CGRect(x: 0, y: 0, width: _self.view.frame.width, height: displayAir ? 315: 215)
                _self.segTableView.topView = _self.headerView
            }
            .disposed(by: disposeBag)
        
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
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.homeInfo }
            .filterNil()
            .subscribe{ [weak self] ev in
                guard let home = ev.element, let _self = self else { return }
                let button = _self.navigationItem.titleView as! UIButton
                let title = home.house?.displayName() ?? ""
                let isOwner = home.house?.isOwner ?? false
                _self.deviceTab.sectionHeaderView.rightBtnHidden = !isOwner
                _self.sceneTab.sectionHeaderView.rightBtnHidden = !isOwner
                button.setTitle(title.trunc(length: 14), for: .normal)
                if (_self.segTableView.refreshHeader.isRefreshing) {
                    _self.segTableView.refreshHeader.endRefreshing()
                }
            }
            .disposed(by: disposeBag)
        
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
            .disposed(by: disposeBag)
        
    }
}

extension HomeViewController: SHSegTableViewDelegate {
    func segTableViewDidScrollY(_ offsetY: CGFloat) {}
    func segTableViewDidScroll(_ tableView: UIScrollView!) {}
    func segTableViewDidScrollSub(_ subTableView: UIScrollView!) { }
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
