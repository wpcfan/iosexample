//
//  SceneListViewController.swift
//  Example
//
//  Created by 王芃 on 2018/11/26.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import Layout
import RxDataSources
import RxSwift

class BasicTableCell: BaseItemCell {
    
}

class SceneListViewController: BaseViewController, TableViewPage, TopTabContent {
    var pageIndex: Int?
    
    @objc var tableView: UITableView? = UITableView().then {
        $0.register(BasicTableCell.self, forCellReuseIdentifier: "cell")
    }
    weak var delegate: UITableViewDelegate?
}

extension SceneListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = tableView
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Int>>(configureCell: { ds, tv, ip, item in
            let cell = tv.dequeueReusableCell(withIdentifier: "cell")
            cell!.textLabel?.text = "Item \(item) \(ip.row)"
            return cell!
        })
        let itemsArr: [Int] = Array(1...100)
        Observable.just([SectionModel(model: "title", items: itemsArr)])
            .bind(to: tableView!.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
