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
import RxOptional
import ReactorKit
import RxQRScanner
import URLNavigator

class HomeViewController: BaseViewController {

    private static let MAX_TOOLBAR_WIDTH: CGFloat = 1.0
    private static let MIN_TOOLBAR_WIDTH: CGFloat = 0.5
    private let navigator = container.resolve(NavigatorType.self)!
    
    private var previousScrollOffset: CGFloat = 0
    
    private var homeTintColor: UIColor = UIColor.white {
        didSet {
            layoutNode?.setState(["homeTintColor": homeTintColor])
        }
    }
    
    private var isLightStyle: Bool = true {
        didSet {
            layoutNode?.setState(["isLightStyle": isLightStyle])
        }
    }
    
    private var homeBarTintColor: UIColor = UIColor.white {
        didSet {
            layoutNode?.setState(["homeBarTintColor": homeBarTintColor])
        }
    }
    
    private var homeBarTranslucent: Bool = false {
        didSet {
            layoutNode?.setState(["isHomeBarTranslucent": homeBarTranslucent])
        }
    }
    
    private var headerHeight: CGFloat = 280 {
        didSet {
            layoutNode?.setState(["headerHeight": headerHeight])
        }
    }
    
    private var toolbarWidth: CGFloat = 0.8 {
        didSet {
            layoutNode?.setState(["toolbarWidth": toolbarWidth])
        }
    }
    
    @objc var imageView: UIImageView!
    
    @objc var tableView: UITableView? {
        didSet {
            tableView?.register(UITableViewCell.self,forCellReuseIdentifier: "cell")
        }
    }
    
    @objc var layoutNode: LayoutNode? {
        didSet {
            layoutNode?.setState([
                "toolbarWidth": toolbarWidth,
                "headerHeight": headerHeight,
                "isHomeBarTranslucent": homeBarTranslucent,
                "homeBarTintColor": homeBarTintColor,
                "isLightStyle": isLightStyle,
                "homeTintColor": homeTintColor
                ])
        }
    }
    
    @objc var bannerView: BannerView!
    
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

    private func setScrollPosition(_ position: CGFloat) {
        self.tableView!.contentOffset = CGPoint(x: self.tableView!.contentOffset.x, y: position)
    }
    
    private func getTopMargin() -> CGFloat {
        var top: CGFloat = 0
        if #available(iOS 11.0, *) {
            top = self.additionalSafeAreaInsets.top
        }
        return top
    }

    // MARK: methods from UIScrollViewDelegate protocol
    fileprivate func animateToolbar(_ alpha: CGFloat) {
        let widthDiff = HomeViewController.MAX_TOOLBAR_WIDTH - HomeViewController.MIN_TOOLBAR_WIDTH
        
        self.toolbarWidth = max(HomeViewController.MAX_TOOLBAR_WIDTH  - alpha * widthDiff, HomeViewController.MIN_TOOLBAR_WIDTH)
        
    }
    
    fileprivate func fadingNavigationBar(_ alpha: CGFloat) {
        self.navigationController?.fadingNavigationBar(alpha: alpha)
    }
    
    fileprivate func animateNavigationBar(_ offsetY: CGFloat, _ distance: CGFloat) {
        
        if (offsetY >= distance) {
            self.navigationController?.presentLightNavigationBar()
            let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
            self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        } else {
            self.navigationController?.presentTransparentNavigationBar(light: true)
            let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        }
    }
    
    fileprivate func animateNavigationBarAndToolBarTransition(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        guard offsetY > 0 else { return }
        let bannerHeight = 0.8 * headerHeight
        let toolbarHeight = 0.2 * headerHeight
        let statusBarHeight = self.navigationController!.getStatusBarHeight()
        let navigationBarHeight = self.navigationController!.getNavigationBarHeight()
        let offsetToSet = bannerHeight + toolbarHeight - navigationBarHeight + toolbarHeight
        if offsetY >= navigationBarHeight + statusBarHeight  {
            scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: offsetToSet), animated: true)
        } else {
            scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: 0), animated: true)
        }
         self.view.layoutIfNeeded()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        print("offsetY", offsetY)
        let scrollDiff = offsetY - self.previousScrollOffset
        print("scrollDiff", scrollDiff)
        
        let bannerHeight = 0.8 * headerHeight
        let statusBarHeight = self.navigationController!.getStatusBarHeight()
        let distance = bannerHeight - statusBarHeight
        let preAlpha = offsetY / distance
        let alpha = offsetY <= 0 ? 0 : preAlpha > 1 ? 1 : preAlpha
        animateToolbar(alpha)
        fadingNavigationBar(alpha)
        animateNavigationBar(offsetY, distance)
        self.previousScrollOffset = offsetY
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            animateNavigationBarAndToolBarTransition(scrollView)
        }
    }
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        animateNavigationBarAndToolBarTransition(scrollView)
//    }
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
            .bind(to: self.imageView.rx.blurImage())
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
