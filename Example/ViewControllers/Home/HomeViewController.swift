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
import SHSegmentedControl
import NVActivityIndicatorView
import Toast_Swift

class HomeViewController: BaseViewController {
    weak var segTableView: SHSegmentedControlTableView!
    weak var segmentControl: SHSegmentControl!
    weak var headerView: UIView!
    
    private let navigator = container.resolve(NavigatorType.self)!
    private let scService = container.resolve(JdSmartCloudService.self)!
    private var refreshHeaderTrigger = PublishSubject<Void>()
    private var loadScenes$ = PublishSubject<Void>()
    private var leftDrawerTransition: DrawerTransition?
    private var sideBarVC: SideBarViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerView = getHeaderView()
//        segmentControl = self.getSegmentControl()
        segTableView = self.getSegTableView()
        segTableView.tableViews = [DeviceTableView(), SceneTableView()]
        view.addSubview(self.segTableView)
        buildRefreshHeader()
        setupNavigationBar()
        setupDrawer()
        reactor = HomeViewControllerReactor()
    }
    func getHeaderView() -> UIView {
        if self.headerView != nil {
            return self.headerView
        }
        return HeaderView()
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
        self.navigationController?.pushViewController(HouseTableViewController(), animated: true)
    }
    @objc func showGroups() {
        
    }
    @objc func showNotifications() {
        
    }
    fileprivate func buildRefreshHeader() {
        weak var weakSelf = self
        let refreshHeader = MJRefreshNormalHeader() {
            weakSelf?.refreshHeaderTrigger.onNext(())
        }
        self.segTableView.refreshHeader = refreshHeader
    }
    fileprivate func buildNavLeftItem() -> Observable<UIBarButtonItem> {
        return Observable.of(buildButtonItem(icon: AppIcons.barMenu, action: #selector(toggle)))
    }
    fileprivate func buildNavRightItems() -> Observable<[UIBarButtonItem]> {
        let groupButtonItem = buildButtonItem(icon: AppIcons.barGroup, action: #selector(showGroups))
        let notificationButtonItem = buildButtonItem(icon: AppIcons.barNotification, action: #selector(showNotifications))
        return Observable.of([notificationButtonItem, groupButtonItem])
    }
    fileprivate func setupNavigationBar() {
        self.navigationController?.presentDarkNavigationBar(UIColor.primary, UIColor.textIcon)
    }
    fileprivate func setupDrawer() {
        weak var `self`: HomeViewController! = self
        sideBarVC = SideBarViewController()
        leftDrawerTransition = DrawerTransition(target: self, drawer: sideBarVC)
        leftDrawerTransition?.edgeType = .left
        leftDrawerTransition?.drawerWidth = UIScreen.main.bounds.width * 0.7
    }
    fileprivate func stopRefreshing(refreshHeader: MJRefreshHeader) {
        weak var header: MJRefreshHeader! = refreshHeader
        if (header.isRefreshing) {
            header.endRefreshing()
        }
    }
}

extension HomeViewController: ReactorKit.View {
    typealias Reactor = HomeViewControllerReactor
    
    func bind(reactor: Reactor) {
        
        weak var `self`: HomeViewController! = self
        weak var headerView: HeaderView! = (self.headerView as! HeaderView)
        weak var deviceTab: DeviceTableView! = (self.segTableView.tableViews[0] as! DeviceTableView)
        weak var sceneTab: SceneTableView! = (self.segTableView.tableViews[1] as! SceneTableView)
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
            .disposed(by: disposeBag)
        
        NEED_REBIND
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.asyncInstance)
            .subscribe{ _ in
                AppDelegate.shared.rootViewController.switchToBindJdAccount()
            }
            .disposed(by: self.disposeBag)
        
        loadScenes$
            .bind(to: sceneTab.loadScenes$)
            .disposed(by: self.disposeBag)
        
        buildNavLeftItem()
            .bind(to: self.navigationItem.rx.leftBarButtonItem)
            .disposed(by: disposeBag)
        
        buildNavRightItems()
            .bind(to: self.navigationItem.rx.rightBarButtonItems)
            .disposed(by: disposeBag)
        
        reactor.state
            .map {$0.homeInfo?.house}
            .filterNil()
            .distinctUntilChanged()
            .map{ $0.displayName().trunc(length: 14) }
            .map{ title in
                UIButton(type: .custom).then {
                    $0.setTitle(title , for: .normal)
                    $0.addTarget(self, action: #selector(self.changeHouse), for: .touchUpInside)
                    $0.sizeToFit()
                }
            }
            .bind(to: self.navigationItem.rx.titleView)
            .disposed(by: disposeBag)
        
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
            .flatMap({ (device) -> Observable<SCDeviceUrl?> in
                self.scService.getDeviceH5V2(feedId: String(device.feedId!))
            })
            .subscribe(onNext: {
                let vc = DeviceV2WebViewController(url: ($0?.h5?.url)!)
                vc.deviceUrl = $0
                self.navigator.push(vc)
            }, onError: { error in
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
            .subscribe { ev in
                guard let url = ev.element else { return }
                self.navigator.push(url)
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
            .subscribe{ ev in
                guard let displayAir = ev.element else { return }
                headerView.displayAir$.onNext(displayAir)
                headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: displayAir ? 315: 215)
                self.segTableView.topView = self.headerView
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.homeInfo }
            .filterNil()
            .subscribe{ ev in
                guard let home = ev.element else {
                    self.stopRefreshing(refreshHeader: self.segTableView.refreshHeader)
                    return
                }
                let isOwner = home.house?.isOwner ?? false
                deviceTab.sectionHeaderView.rightBtnHidden = !isOwner
                sceneTab.sectionHeaderView.rightBtnHidden = !isOwner
                self.stopRefreshing(refreshHeader: self.segTableView.refreshHeader)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.errorMessage }
            .filter({ (msg) -> Bool in !msg.isBlank })
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.asyncInstance)
            .subscribe{ ev in
                guard let err = ev.element else { return }
                self.view.makeToast(err)
            }
            .disposed(by: disposeBag)
    }
}

extension HomeViewController: SHSegTableViewDelegate {
    func segTableViewDidScrollY(_ offsetY: CGFloat) {}
    func segTableViewDidScroll(_ tableView: UIScrollView!) {}
    func segTableViewDidScrollSub(_ subTableView: UIScrollView!) { }
    func segTableViewDidScrollProgress(_ progress: CGFloat, originalIndex: Int, targetIndex: Int) {
        if (progress == 1 && targetIndex == 1) {
            loadScenes$.onNext(())
            //            self.segmentControl.setSegmentSelectedIndex(targetIndex)
        }
    }
}

extension HomeViewController: DrawerTransitionDelegate {
    @objc func toggle()  {
        self.leftDrawerTransition?.presentDrawerViewController(animated: true)
    }
}
