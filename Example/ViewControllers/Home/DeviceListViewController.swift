//
//  DeviceListViewController.swift
//  Example
//
//  Created by 王芃 on 2018/11/26.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import RxSwift
import RxDataSources

class DeviceListViewController: BaseViewController, TableViewPage, TopTabContent {
    
    var pageIndex: Int?
    var devices$ = BehaviorSubject<[Device]>(value: [])
    private var refreshHeaderTrigger = PublishSubject<Void>()
    
    @objc var tableView: UITableView? = UITableView().then {
        $0.register(BasicTableCell.self, forCellReuseIdentifier: "cell")
    }
    
    weak var delegate: UITableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.delegate = self
        self.view = tableView
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Device>>(configureCell: { ds, tv, ip, item in
            let cell = tv.dequeueReusableCell(withIdentifier: "cell")
            cell!.textLabel?.text = item.deviceName
            cell!.imageView?.pin_setImage(from: URL(string: item.productImageUrl ?? ""), placeholderImage: AppIcons.devicePlaceholder)
            return cell!
        })
        
        devices$
            .map{ devices in
                [SectionModel(model: "我的设备", items: devices)]
            }
            .bind(to: (tableView?.rx.items(dataSource: dataSource))!)
            .disposed(by: disposeBag)
    }
}

extension DeviceListViewController: UITableViewDelegate {
    fileprivate func buildSectionHeader() -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.white
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "我的设备"
        let icon = UIImageView(image: AppIcons.scene)
        icon.pin.width(20).height(20)
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
