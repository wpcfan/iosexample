//
//  HouseTableViewController.swift
//  Example
//
//  Created by 王芃 on 2019/2/1.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import RxDataSources
import RxSwift
import PinLayout
import ReactorKit
import Layout

class HouseCell: BaseItemCell {
    var house: House? {
        didSet {
            guard let house = house else { return }
            houseNameLabel!.text = house.displayName()
            groupCountLabel!.text = "分组:\(house.groupCount ?? 0)"
            deviceCountLabel!.text = "设备:\(house.deviceCount ?? 0)"
            familyCountLabel!.text = "家人:\(house.familyMemberCount ?? 0)"
            sceneCountLabel!.text = "场景:\(house.sceneCount ?? 0)"
        }
    }
    var icon: UIImageView?
    var houseNameLabel: UILabel?
    var groupCountLabel: UILabel?
    var deviceCountLabel: UILabel?
    var familyCountLabel: UILabel?
    var sceneCountLabel: UILabel?
    var selectedIcon: UIImageView?
    
    override func initialize() {
        super.initialize()
        
        icon = UIImageView().then {
            $0.image = AppIcons.home
        }
        self.contentView.addSubview(icon!)
        houseNameLabel = UILabel().then {
            $0.font = UIFont.systemFont(ofSize: 14)
            $0.textAlignment = .left
        }
        self.contentView.addSubview(houseNameLabel!)
        groupCountLabel = UILabel().then {
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.textAlignment = .center
            $0.textColor = .white
            $0.backgroundColor = .primary
        }
        self.contentView.addSubview(groupCountLabel!)
        deviceCountLabel = UILabel().then {
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.textAlignment = .center
            $0.textColor = .white
            $0.backgroundColor = .primary
        }
        self.contentView.addSubview(deviceCountLabel!)
        familyCountLabel = UILabel().then {
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.textAlignment = .center
            $0.textColor = .white
            $0.backgroundColor = .primary
        }
        self.contentView.addSubview(familyCountLabel!)
        sceneCountLabel = UILabel().then {
            $0.font = UIFont.systemFont(ofSize: 12)
            $0.textAlignment = .center
            $0.textColor = .white
            $0.backgroundColor = .primary
        }
        self.contentView.addSubview(sceneCountLabel!)
        selectedIcon = UIImageView().then {
            $0.image = AppIcons.checkCircle
        }
        self.contentView.addSubview(selectedIcon!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        icon!.pin.left().vCenter().width(30).height(30)
        houseNameLabel!.pin.after(of: icon!).top(5).sizeToFit(.widthFlexible)
        groupCountLabel!.pin.below(of: houseNameLabel!, aligned: .left).sizeToFit(.widthFlexible).bottom()
        deviceCountLabel!.pin.right(of: groupCountLabel!, aligned: .center).sizeToFit(.widthFlexible).height(of: groupCountLabel!)
        familyCountLabel!.pin.right(of: deviceCountLabel!, aligned: .center).width(40).height(of: groupCountLabel!)
        sceneCountLabel!.pin.right(of: familyCountLabel!, aligned: .center).sizeToFit(.widthFlexible).height(of: groupCountLabel!)
        selectedIcon!.pin.right(5).vCenter().width(20).height(20)
    }
}

class HouseTableViewController: BaseViewController, LayoutLoading {
    
    @objc weak var tableView: UITableView!
    
    private var titleForDefault = UILabel().then {
        $0.text = "myhouses.title".localized
        $0.textColor = UIColor.textIcon
        $0.textAlignment = .center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadLayout(named: "HouseTableViewController.xml")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.titleView = titleForDefault
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
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, House>>(configureCell: { ds, tv, ip, item in
            let node = tv.dequeueReusableCellNode(withIdentifier: "houseCell")!
            node.setState([
                "houseIcon": AppIcons.home,
                "displayName": item.displayName()
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
    }
}
