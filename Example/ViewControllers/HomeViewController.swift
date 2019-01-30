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
import ReactorKit
import RxQRScanner
import URLNavigator
import CoreGraphics
import PinLayout
import NotificationBannerSwift

class HomeViewController: BaseViewController {

    private let navigator = container.resolve(NavigatorType.self)!
    private var previousScrollOffset: CGFloat = 0
    private var leftMenu: UIViewController?
    private var leftDrawerTransition: DrawerTransition?
    private var titleForDefault = UILabel().then {
        $0.text = "home.navigation.title".localized
        $0.textColor = UIColor.textIcon
        $0.textAlignment = .center
    }

    private var titleForTranslucent = HomeTitleView()
    
    @objc weak var bannerView: BannerView!
    @objc var tableView: UITableView? {
        didSet {
            guard let tableView = tableView else { return }
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            let refreshHeader = PullToRefreshUtil.createHeader()
            tableView.configRefreshHeader(with: refreshHeader, container:self) { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                    self?.tableView?.reloadData()
                    self?.tableView?.switchRefreshHeader(to: .normal(.success, 0.3))
                }
            }
        }
    }

    
    @objc public func scanInModalAction() {
        RxQRUtil().scanQR(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadLayout(named: "HomeViewController.xml",
                        state: [
                            "hasNoHouse": true
                        ],
                        constants: [
                            "uppercased": LayoutFunctions.upperCase,
                            "iconTabHome": AppIcons.home,
                            "iconTabSocial": AppIcons.social,
                            "iconTabMy": AppIcons.user,
                            "iconAdd": AppIcons.add,
                            "iconSettings": AppIcons.settingsAccent,
                            "iconMenu": AppIcons.menu,
                            "iconHome": AppIcons.home,
                            "emptyImage": UIImage()
                        ]
        )
    }
    
    fileprivate func buildNavTopItem() {
        // Top Button
        let topButton = UIButton(type: .custom).then {
            $0.setTitle("首页", for: .normal)
            $0.addTarget(self, action: #selector(HomeViewController.changeHouse), for: .touchUpInside)
            $0.sizeToFit()
        }
        self.navigationItem.titleView = topButton
    }
    
    fileprivate func buildNavLeftItem() {
        // Left Button
        let leftButton: UIButton = UIButton(type: .custom)
        leftButton.setImage(AppIcons.menu, for: .normal)
        leftButton.addTarget(self, action: #selector(HomeViewController.toggle), for: .touchUpInside)
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: leftButton)
        
        self.navigationItem.setLeftBarButton(leftBarButtonItem, animated: false);
    }
    
    fileprivate func setupNavigationBar() {
        self.navigationController?.presentDarkNavigationBar(UIColor.primary, UIColor.textIcon)
        buildNavTopItem()
        buildNavLeftItem()
    }
    
    @objc func changeHouse() {
    
    }
}

extension HomeViewController: UITableViewDataSource {
    
    // rows in section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    // dequeue cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",   for: indexPath as IndexPath)
        cell.textLabel?.text = "Article \(indexPath.row)"
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    fileprivate func buildSectionHeader() -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.white
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "我的场景"
        let icon = UIImageView(image: AppIcons.scene)
        view.addSubview(icon)
        view.addSubview(label)
        icon.pin.left(5).top(5).width(24).height(24)
        label.pin.after(of: icon).width(200).height(24).top(5).marginLeft(5)
        view.sizeToFit()
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return buildSectionHeader()
    }
}

extension HomeViewController: StoryboardView {
    typealias Reactor = HomeViewControllerReactor
    
    func bind(reactor: Reactor) {
        reactor.action.onNext(.load)
        
        self.bannerView.rx.bannerImageTap
            .subscribe { ev in
                guard let target = ev.element else { return }
                self.navigator.present(target)
            }
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.homeInfo }
            .subscribe{ ev in
                guard let home = ev.element else { return }
                self.bannerView.banners = home?.banners ?? []
            }
            .disposed(by: self.disposeBag)
        
        reactor.state
            .map { $0.errorMessage }
            .filter({ (msg) -> Bool in
                !msg.isBlank
            })
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

extension HomeViewController: LayoutLoading {
    func layoutDidLoad(_: LayoutNode) {
        leftMenu = SideBarViewController()
        leftDrawerTransition = DrawerTransition(target: self, drawer: leftMenu)
        leftDrawerTransition?.setPresentCompletion { print("left present...") }
        leftDrawerTransition?.setDismissCompletion { print("left dismiss...") }
        leftDrawerTransition?.edgeType = .left
        self.reactor = HomeViewControllerReactor()
    }
}

extension HomeViewController: DrawerTransitionDelegate {
    @objc func toggle()  {
        self.leftDrawerTransition?.presentDrawerViewController(animated: true)
    }
}
