//
//  HouseTableViewController.swift
//  Example
//
//  Created by 王芃 on 2019/2/1.
//  Copyright © 2019 twigcodes. All rights reserved.
//
import RxDataSources
import RxSwift
import ReactorKit
import Layout

class HouseTableViewController: BaseViewController, LayoutLoading {
    private let scService = container.resolve(JdSmartCloudService.self)!
    @objc weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadLayout(named: "HouseTableViewController.xml")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "myhouses.title".localized
    }
    
    func layoutDidLoad(_: LayoutNode) {
        self.reactor = HouseTableViewControllerReactor()
    }
}


extension HouseTableViewController: UITableViewDelegate {
    
}

extension HouseTableViewController: StoryboardView {
    typealias Reactor = HouseTableViewControllerReactor
    
    func bind(reactor: Reactor) {
        reactor.action.onNext(.load)
        weak var `self`: HouseTableViewController! = self
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, House>>(configureCell: { ds, tv, ip, item in
            let node = tv.dequeueReusableCellNode(withIdentifier: "houseCell")!
            let data = DiskUtil.getData()
            node.setState([
                "houseIcon": AppIcons.homePrimary,
                "displayName": item.displayName(),
                "groupsCount": "\("myhouses.groupscount".localized)\(item.groupCount!)",
                "devicesCount": "\("myhouses.devicescount".localized)\(item.deviceCount!)",
                "familyCount": "\("myhouses.familycount".localized)\(item.familyMemberCount!)",
                "scenesCount": "\("myhouses.scenescount".localized)\(item.sceneCount!)",
                "checkIcon": AppIcons.checkCircle,
                "selected": data?.houseId == item.id
                ])
            return node.view as! UITableViewCell
        })
        
        reactor.state
            .map { (state) -> [House] in
                state.houses
            }
            .map { (houses) -> [SectionModel<String, House>] in
                [SectionModel(model: "我的房屋", items: houses)]
            }
            .bind(to: (self.tableView.rx.items(dataSource: dataSource)))
            .disposed(by: self.disposeBag)
        
        tableView.rx.modelSelected(House.self)
            .subscribe(onNext: {
                let originalData = DiskUtil.getData()
                if ($0.id != originalData?.houseId) {
                    DiskUtil.saveHouseInfo(house: $0)
                    #if !targetEnvironment(simulator)
                    self.scService.changeToken()
                    #endif
                    CURRENT_HOUSE.onNext($0)
                }
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: self.disposeBag)
    }
}
