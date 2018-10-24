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
import RxSwiftExt
import RxCocoa
import ReactorKit
import RxQRScanner
import RxDataSources

enum ScrollTarget {
    case originTop
    case scrollUp
    case pullToRefresh
    case headerInsetTop
}

class HomeViewController: BaseViewController, View {
    
    typealias Reactor = HomeViewReactor
    
    private var dataSource: RxTableViewSectionedReloadDataSource<MultipleSectionModel>?
    
//    private var tableView: UITableView = UITableView().then {
//        $0.register(BannerCell.self, forCellReuseIdentifier: BannerCell.reuseIdentifier)
//        $0.register(ChannelCell.self, forCellReuseIdentifier: ChannelCell.reuseIdentifier)
//        $0.register(SceneCell.self, forCellReuseIdentifier: SceneCell.reuseIdentifier)
//    }
    var headerHeight: CGFloat = 150

    @IBOutlet var tableView: UITableView? {
        didSet {
            tableView?.register(UITableViewCell.self,forCellReuseIdentifier: "cell")
            tableView?.tableHeaderView = nil
        }
    }
    
    @IBOutlet var layoutNode: LayoutNode? {
        didSet {
            layoutNode?.setState(["headerHeight": headerHeight], animated: true)
        }
    }
    
    @IBAction public func scanInModalAction() {
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
        
//        self.view.addSubview(tableView)
//        tableView.snp.makeConstraints { make in
//            make.top.bottom.left.right.equalToSuperview()
//        }
//
//        // set up data source
//        let dataSource = HomeViewController.dataSource()
//        self.dataSource = dataSource
//        Observable.just(self.buildSections())
//            .bind(to: (tableView.rx.items(dataSource: self.dataSource!)))
//            .disposed(by: self.disposeBag)
//        // set up delegate
//        tableView.rx.setDelegate(self)
//            .disposed(by: self.disposeBag)
//        // watch the offset
//        let rx_offset = tableView.rx.contentOffset
//        rx_offset
//            .debounce(0.1, scheduler: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
//            .map { $0.y }
//            .skip(1)
//            .map({ (offsetY) -> ScrollTarget in
//                if (offsetY.isEqual(to: 192)) {
//                    return .headerInsetTop
//                } else if (offsetY.isEqual(to: -88)) {
//                    return .originTop
//                } else if (offsetY.isLess(than: -88)) {
//                    return .pullToRefresh
//                } else {
//                    return .scrollUp
//                }
//            })
//            .distinctUntilChanged()
//            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
//            .observeOn(MainScheduler.instance)
//            .subscribe {
//                switch $0.element! {
//
//                case .originTop:
//                    print("[originTop] tableView.contentInset.top:", self.tableView.contentInset.top)
//                    print("[originTop] tableView.contentOffset:", self.tableView.contentOffset)
//                case .scrollUp:
//                    let scrollIndicatorInsets = self.tableView.scrollIndicatorInsets
//                    let contentOffset = self.tableView.contentOffset
//                    self.tableView.contentInset.top = 280 - 88
////                    self.tableView.scrollIndicatorInsets = scrollIndicatorInsets
//                    self.tableView.contentOffset.y = contentOffset.y + 192
//                    print("[scrollUp] tableView.contentInset.top:", self.tableView.contentInset.top)
//                    print("[scrollUp] tableView.contentOffset:", self.tableView.contentOffset)
//                case .pullToRefresh:
//                    print("[pullToRefresh] tableView.contentInset.top:", self.tableView.contentInset.top)
//                    print("[pullToRefresh] tableView.contentOffset:", self.tableView.contentOffset)
//                case .headerInsetTop:
//                    print("[headerInsetTop] tableView.contentInset.top:", self.tableView.contentInset.top)
//                    print("[headerInsetTop] tableView.contentOffset:", self.tableView.contentOffset)
//                }
//            }
//            .disposed(by: self.disposeBag)
        
    }
    
    func bind(reactor: Reactor) {
        
    }
    
    func animateHeader() {
        self.headerHeight = 150
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.layoutNode?.setState(["headerHeight": self.headerHeight])
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func buildSections() -> [MultipleSectionModel] {
        let banners = [
            Banner(id: "1", imageUrl: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080", label: "first", link: "http://baidu.com"),
            Banner(id: "1", imageUrl: "https://images.unsplash.com/photo-1447746249824-4be4e1b76d66?w=1080", label: "second", link: "http://baidu.com"),
            Banner(id: "1", imageUrl: "https://images.unsplash.com/photo-1463595373836-6e0b0a8ee322?w=1080", label: "third", link: "http://baidu.com")
        ]
        let channels = [
            Banner(id: "1", imageUrl: "https://image.flaticon.com/icons/png/512/138/138281.png", label: "first", link: "http://baidu.com"),
            Banner(id: "1", imageUrl: "https://image.flaticon.com/icons/png/512/148/148982.png", label: "second", link: "http://baidu.com"),
            Banner(id: "1", imageUrl: "https://image.flaticon.com/icons/png/512/1006/1006555.png", label: "third", link: "http://baidu.com"),
            Banner(id: "1", imageUrl: "https://image.flaticon.com/icons/png/512/1087/1087840.png", label: "third", link: "http://baidu.com"),
            Banner(id: "1", imageUrl: "https://image.flaticon.com/icons/png/512/148/148717.png", label: "third", link: "http://baidu.com")
        ]
        let scene = Scene(id: "1", name: "go home", sceneIcon: SceneIcon.goHome, builtIn: true, order: 1, countOfDevices: 2, trigger: nil, tasks: [])
        let sections: [MultipleSectionModel] = [
            .banners(title: "Section 1",
                     items: [.bannerItem(banners: banners, title: "General")]),
            .channels(title: "Section 2",
                      items: [.channelItem(channels: channels, title: "channels")]),
            .scenes(title: "Section 3",
                    items: [.sceneItem(scene: scene, title: "1")])
        ]
        return sections
    }

}

//extension HomeViewController {
//    static func dataSource() -> RxTableViewSectionedReloadDataSource<MultipleSectionModel> {
//        return RxTableViewSectionedReloadDataSource<MultipleSectionModel>(
//            configureCell: { (dataSource, table, idxPath, _) in
//                switch dataSource[idxPath] {
//                case let .bannerItem(banners, _):
//                    let cell: BannerCell = table.dequeueReusableCell(forIndexPath: idxPath)
//                    cell.banners = banners
//
//                    return cell
//                case let .sceneItem(scene, _):
//                    let cell: SceneCell = table.dequeueReusableCell(forIndexPath: idxPath)
//                    cell.scene = scene
//
//                    return cell
//                case let .channelItem(channels, _):
//                    let cell: ChannelCell = table.dequeueReusableCell(forIndexPath: idxPath)
//                    cell.channels = channels
//
//                    return cell
//                }
//            },
//            titleForHeaderInSection: { dataSource, index in
//                let section = dataSource[index]
//                switch section {
//                case .banners(_, _):
//                    return nil
//                case .channels(_, _):
//                    return nil
//                case .scenes(_, _):
//                    return section.title
//                }
//            }
//        )
//    }
//}

//extension HomeViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch indexPath.section {
//        case 0:
//            return tableView.frame.size.height / 5
//        case 1:
//            return 88
//        default:
//            return UITableView.automaticDimension
//        }
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        switch section {
//        case 0, 1:
//            return CGFloat.leastNonzeroMagnitude
//        default:
//            return UITableView.automaticDimension
//        }
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        var rect = self.view.frame;
//        rect.origin.y += previousOffset - scrollView.contentOffset.y;
//        previousOffset = scrollView.contentOffset.y;
//        self.view.frame = rect;
//        print("contentOffset.y: ", scrollView.contentOffset.y)
//        print("contentInset.top: ", scrollView.contentInset.top)
//    }
//}
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",   for: indexPath as IndexPath)
        cell.textLabel?.text = "Article \(indexPath.row)"
        return cell
    }
}

extension HomeViewController:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            headerHeight += abs(scrollView.contentOffset.y) / 100
            
        } else if scrollView.contentOffset.y > 0 && self.headerHeight >= 65 {
            self.headerHeight -= scrollView.contentOffset.y/100
            if self.headerHeight < 65 {
                self.headerHeight = 65
            }
        }
        print("contentOffset.y", scrollView.contentOffset.y)
        print("headerHeight", self.headerHeight)
        layoutNode?.setState(["headerHeight": headerHeight])
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.headerHeight > 150 {
            animateHeader()
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.headerHeight > 150 {
            animateHeader()
        }
    }
}
extension HomeViewController:UITableViewDelegate {
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            switch section {
            case 0:
                return CGFloat.leastNonzeroMagnitude
            default:
                return UITableView.automaticDimension
            }
        }
}
