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

class HomeViewController: BaseViewController {

    private static let maxHeaderHeight: CGFloat = 192
    private static let minHeaderHeight: CGFloat = 0
    
    private var previousScrollOffset: CGFloat = -88
    private var headerHeight: CGFloat = maxHeaderHeight {
        didSet {
            layoutNode?.setState(["headerHeight": headerHeight])
        }
    }
    private var headerAlpha: CGFloat = 1 {
        didSet {
            layoutNode?.setState(["headerAlpha": headerAlpha])
        }
    }
    
    @objc var tableView: UITableView? {
        didSet {
            tableView?.register(UITableViewCell.self,forCellReuseIdentifier: "cell")
        }
    }
    
    @objc var layoutNode: LayoutNode? {
        didSet {
            layoutNode?.setState([
                "headerHeight": headerHeight,
                "headerAlpha": headerAlpha
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
    private func canAnimateHeader(_ scrollView: UIScrollView) -> Bool {
        // Calculate the size of the scrollView when header is collapsed
        let scrollViewMaxHeight = scrollView.frame.height + self.headerHeight - HomeViewController.minHeaderHeight
        
        // Make sure that when header is collapsed, there is still room to scroll
        return scrollView.contentSize.height > scrollViewMaxHeight
    }
    
    private func scrollViewDidStopScrolling() {
        let range = HomeViewController.maxHeaderHeight - HomeViewController.minHeaderHeight
        let midPoint = HomeViewController.minHeaderHeight + (range / 2)
        
        if self.headerHeight > midPoint {
            self.expandHeader()
        } else {
            self.collapseHeader()
        }
    }
    
    private func collapseHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeight = HomeViewController.minHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }
    
    private func expandHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeight = HomeViewController.maxHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }
    
    private func setScrollPosition(_ position: CGFloat) {
        self.tableView!.contentOffset = CGPoint(x: self.tableView!.contentOffset.x, y: position)
    }
    
    private func updateHeader() {
        let range = HomeViewController.maxHeaderHeight - HomeViewController.minHeaderHeight
        let openAmount = self.headerHeight - HomeViewController.minHeaderHeight
        let percentage = openAmount / range
        
        self.headerAlpha = percentage
    }
    // MARK: methods from UIScrollViewDelegate protocol
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let scrollDiff = offsetY - self.previousScrollOffset
        let isScrollingDown = scrollDiff < 0
        let isScrollingUp = scrollDiff > 0
        if isScrollingDown {
            self.headerHeight -= abs(scrollDiff)
            self.updateHeader()
            self.setScrollPosition(self.previousScrollOffset)
        }
        if isScrollingUp {
            self.headerHeight += abs(scrollDiff)
            self.updateHeader()
            self.setScrollPosition(self.previousScrollOffset)
        }
        self.previousScrollOffset = offsetY
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollViewDidStopScrolling()
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidStopScrolling()
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

extension HomeViewController: View {
    typealias Reactor = HomeViewReactor
    func bind(reactor: Reactor) {
        
    }
}
