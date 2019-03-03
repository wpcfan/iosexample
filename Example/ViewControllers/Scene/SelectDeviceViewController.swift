//
//  SelectDeviceViewController.swift
//  Example
//
//  Created by 王芃 on 2019/3/3.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import Layout
import RxDataSources
import RxSwift
import RxCocoa

class SelectDeviceViewController: BaseViewController {
    var devices$ = PublishRelay<[Device]>()
    @objc weak var tableView: UITableView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLayout(named: "SelectDeviceViewController.xml")
    }
}

extension SelectDeviceViewController: LayoutLoading {
    func layoutDidLoad(_: LayoutNode) {
        
        weak var `self`: SelectDeviceViewController! = self
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Device>>(configureCell: { ds, tv, ip, item in
            let node = tv.dequeueReusableCellNode(withIdentifier: "cell")
            node?.setState([
                "row": ip.row,
                "imageUrl": item.productImageUrl ?? ""
                ])
            return node?.view as! UITableViewCell
        })
        
        devices$.map{ devices in [SectionModel(model: "devices.section.header".localized, items: devices)] }
            .debug()
            .bind(to: self.tableView!.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
