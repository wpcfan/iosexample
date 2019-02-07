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
import Dollar

class BasicTableCell: BaseTableCell {
    
}

class SceneListViewController: BaseViewController, TableViewPage, TopTabContent {
    var pageIndex: Int?
    var scenes$ = BehaviorSubject<[Scene]>(value: [
        Scene(JSON: ["name": "回家"])!,
        Scene(JSON: ["name": "离家"])!])
    
    @objc var tableView: UITableView? = UITableView().then {
        $0.register(BasicTableCell.self, forCellReuseIdentifier: "cell")
    }
    weak var delegate: UITableViewDelegate?
}

extension SceneListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageIndex = 0
        tableView?.delegate = self
        self.view = tableView
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Scene>>(configureCell: { ds, tv, ip, item in
            let cell = tv.dequeueReusableCell(withIdentifier: "cell")
            cell!.textLabel?.text = item.name
            return cell!
        })
        scenes$
            .map { scenes in
                [SectionModel(model: "title", items: scenes)]
            }
            .bind(to: self.tableView!.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension SceneListViewController: UITableViewDelegate {
    fileprivate func buildSectionHeader() -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.white
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "我的场景"
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
