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
import Toast_Swift

class HomeViewController: BaseViewController {
    weak var segTableView: SHSegmentedControlTableView!
    weak var segmentControl: SHSegmentControl!
    weak var headerView: UIView!
    var deviceTab: DeviceTableView!
    var sceneTab: SceneTableView!
    private let navigator = container.resolve(NavigatorType.self)!
    private let scService = container.resolve(JdSmartCloudService.self)!
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
        let leftBarButtonItem = buildButtonItem(icon: AppIcons.menu, action: #selector(toggle))
        self.navigationItem.setLeftBarButton(leftBarButtonItem, animated: false);
    }
    fileprivate func buildNavRightItems() {
        let groupButtonItem = buildButtonItem(icon: AppIcons.group, action: #selector(showGroups))
        let messageButtonItem = buildButtonItem(icon: AppIcons.message, action: #selector(showMessages))
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
            .filter { device in device.version == ProductVersion.two.verVal }
            .do(onNext: { (_) in
                self.toggleLoading(true)
            })
            .flatMap({ (device) -> Observable<SCDeviceUrl?> in
                self.scService.getDeviceH5V2(feedId: String(device.feedId!))
            })
            .subscribe(onNext: {
                self.toggleLoading(false)
                let vc = DeviceV2WebViewController(url: ($0?.h5?.url)!)
                vc.deviceUrl = $0
                self.navigator.push(vc)
            }, onError: { error in
                self.toggleLoading(false)
                self.view.makeToast(convertErrorToString(error: error))
            })
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
                _self.navigator.push(url)
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
                guard let loading = ev.element, !self.segTableView.refreshHeader.isRefreshing else {  return }
                self.toggleLoading(loading)
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
