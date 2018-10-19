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
import AVFoundation
import ReactorKit
import RxQRScanner

class HomeViewController: BaseViewController, LayoutLoading {
    
    private let viewModel = HomeViewModel()
    
    @IBOutlet var tableView: UITableView? {
        didSet {
            tableView?.delegate = viewModel
            tableView?.dataSource = viewModel
            
            tableView?.register(BannerCell.nib, forCellReuseIdentifier: BannerCell.identifier)
            tableView?.register(ChannelCell.nib, forCellReuseIdentifier: ChannelCell.identifier)
            tableView?.registerLayout(
                named: "SceneCell.xml",
                forCellReuseIdentifier: "SceneCell")
            tableView?.configRefreshHeader(
                with: TableViewUtils.createHeader(),
                container: self,
                action: {
                    log.debug("add refresh header to table view")
                    self.tableView?.reloadData()
                    self.tableView?.switchRefreshHeader(to: .normal(.success, 0.3))
            })
        }
    }
    
    @IBAction public func scanInModalAction() {
        
        var config = QRScanConfig.instance
        config.titleText = NSLocalizedString("qrscanner.navigation.title", comment: "")
        config.albumText = NSLocalizedString("qrscanner.navigation.right.title", comment: "")
        config.cancelText = NSLocalizedString("qrscanner.navigation.left.title", comment: "")
        Permission.checkCameraAccess()
            .filter { (hasAccess) -> Bool in hasAccess }
            .flatMap({ (_) -> Observable<QRScanResult> in
                QRScanner.popup(on: self, config: config)
            })
            .map({ (result) -> String? in
                if case let .success(str) = result { return str }
                return nil
            })
            .take(1)
            .subscribe(onNext: { result in
                log.debug(result!)
            })
            .disposed(by: disposeBag)
    }
}
