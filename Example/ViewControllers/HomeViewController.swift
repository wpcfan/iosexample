//
//  HomeViewController.swift
//  Example
//
//  Created by 王芃 on 2018/9/30.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import UIKit
import Layout
import RxSwift
import RxCocoa
import ReactorKit
import RxQRScanner
import URLNavigator
import CoreGraphics

class HomeViewController: BaseViewController {

    private static let MAX_TOOLBAR_WIDTH: CGFloat = 0.8
    private static let MIN_TOOLBAR_WIDTH: CGFloat = 0.5
    private let navigator = container.resolve(NavigatorType.self)!
    private var previousScrollOffset: CGFloat = 0
    
    private var titleForDefault = UILabel().then {
        $0.text = NSLocalizedString("home.navigation.title", comment: "")
        $0.textColor = UIColor.textIcon
        $0.textAlignment = .center
    }

    private var titleForTranslucent = HomeTitleView()
    
    private var bannerHeight: CGFloat = 220 {
        didSet {
            layoutNode?.setState(["bannerHeight": bannerHeight])
        }
    }
    
    private var toolbarHeight: CGFloat = 44 {
        didSet {
            layoutNode?.setState(["toolbarHeight": toolbarHeight])
        }
    }
    
    private var toolbarWidth: CGFloat = MAX_TOOLBAR_WIDTH {
        didSet {
            layoutNode?.setState(["toolbarWidth": toolbarWidth])
        }
    }
    @objc var imageView: UIImageView?
    @objc var bannerView: BannerView!
    @objc var tableView: UITableView? {
        didSet {
            guard let tableView = tableView else { return }
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            let refreshHeader = HomeRefreshHeader()
            tableView.configRefreshHeader(with: refreshHeader, container:self) { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                    self?.tableView?.reloadData()
                    self?.tableView?.switchRefreshHeader(to: .normal(.success, 0.3))
                }
            }
        }
    }
    
    @objc var layoutNode: LayoutNode? {
        didSet {
            layoutNode?.setState([
                "toolbarWidth": toolbarWidth,
                "bannerHeight": bannerHeight,
                "toolbarHeight": toolbarHeight,
                ])
        }
    }
    
    @objc public func scanInModalAction() {
        var config = QRScanConfig.instance
        config.titleText = NSLocalizedString("qrscanner.navigation.title", comment: "")
        config.albumText = NSLocalizedString("qrscanner.navigation.right.title", comment: "")
        config.cancelText = NSLocalizedString("qrscanner.navigation.left.title", comment: "")
        Permission.checkCameraAccess()
            .filter { (hasAccess) -> Bool in hasAccess }
            .flatMap{ _ in QRScanner.popup(on: self, config: config) }
            .map({ (result) -> String? in
                if case let .success(str) = result { return str }
                return nil
            })
            .take(1)
            .subscribe(onNext: { result in
                if (result != nil) {
                    log.debug(result!)
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.titleView?.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(HomeViewController.MIN_TOOLBAR_WIDTH * self.view.frame.width)
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    // Section Header Title
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
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

extension HomeViewController: UIScrollViewDelegate {
    
    fileprivate func getAlpha(_ scrollView: UIScrollView) -> CGFloat {
        let offsetY = scrollView.contentOffset.y
        let statusBarHeight = self.navigationController!.getStatusBarHeight()
        let preAlpha = offsetY / (bannerHeight - statusBarHeight)
        return offsetY <= 0 ? 0 : preAlpha > 1 ? 1 : preAlpha
    }
    
    fileprivate func scaleHeaderImage(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        guard offsetY < 0 else { return }
        let scaleTo = 1 - offsetY / scrollView.frame.size.height
        self.imageView!.transform = CGAffineTransform(scaleX: scaleTo, y: scaleTo)
    }
    
    fileprivate func animateToolbar(_ scrollView: UIScrollView) {
        let alpha = getAlpha(scrollView)
        let widthDiff = HomeViewController.MAX_TOOLBAR_WIDTH - HomeViewController.MIN_TOOLBAR_WIDTH
        self.toolbarWidth = max(HomeViewController.MAX_TOOLBAR_WIDTH  - alpha * widthDiff, HomeViewController.MIN_TOOLBAR_WIDTH)
        self.navigationController?.fadingNavigationBar(alpha: alpha)
        self.navigationController?.navigationBar.tintColor = alpha == 1 ? .black : .white
        self.navigationItem.titleView = alpha == 1 ? titleForTranslucent : titleForDefault
    }

    fileprivate func animateNavigationBarAndToolBarTransition(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        guard offsetY > 0 else { return }
        let statusBarHeight = self.navigationController!.getStatusBarHeight()
        let navigationBarHeight = self.navigationController!.getNavigationBarHeight()
        // translucent bar
        if offsetY >= 0 && offsetY <= bannerHeight - statusBarHeight - navigationBarHeight {
            scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: 0), animated: true)
        }
        // default bar
        if offsetY > bannerHeight - statusBarHeight - navigationBarHeight {
            scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: bannerHeight - statusBarHeight), animated: true)
        }
        self.view.layoutIfNeeded()
    }
    
    // MARK: methods from UIScrollViewDelegate protocol
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        animateToolbar(scrollView)
        scaleHeaderImage(scrollView)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            animateNavigationBarAndToolBarTransition(scrollView)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.previousScrollOffset = scrollView.contentOffset.y
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return CGFloat.leastNonzeroMagnitude
        default:
            return UITableView.automaticDimension
        }
    }
}

extension HomeViewController: ReactorKit.StoryboardView {
    typealias Reactor = HomeViewControllerReactor
    
    func bind(reactor: Reactor) {
        
        self.bannerView.rx.bannerImageSelect
            .bind(to: self.imageView!.rx.blurImage())
            .disposed(by: self.disposeBag)
        
        self.bannerView.rx.bannerImageTap
            .subscribe { ev in
                if (ev.element != nil) {
                    self.navigator.present(ev.element!)
                }
            }
            .disposed(by: self.disposeBag)
    }
}
