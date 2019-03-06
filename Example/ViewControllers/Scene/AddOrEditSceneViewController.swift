//
//  AddOrEditSceneViewController.swift
//  Example
//
//  Created by 王芃 on 2019/3/1.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import Layout
import RxSwift
import RxCocoa
import RxDataSources

class AddOrEditSceneViewController: BaseViewController, LayoutLoading {
    var scene: HouseScene? {
        didSet {
            guard let events = scene?.scene?.script?.events, let actions = scene?.scene?.script?.actions else { return }
            self.events$.accept(events)
            self.actions$.accept(actions)
        }
    }
    @objc weak var tableView: UITableView?
    @objc weak var sceneNameField: UITextField?
    @objc weak var sceneActiveSwitch: UISwitch?
    @objc weak var leftBadgeView: UIView?
    let events$ = BehaviorRelay<[ScriptEvent]>(value: [])
    let actions$ = BehaviorRelay<[ScriptAction]>(value: [])
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = scene?.scene?.script == nil ? "新建场景" : "编辑场景"
        
        loadLayout(named: "AddOrEditSceneViewController.xml",
                   state: [
                    "sceneName": scene?.scene?.displayName ?? "未命名",
                    "sceneActive": scene?.scene?.scriptStatus ?? true
                    ],
                   constants: [
                    "circle": AppIcons.circle,
                    "setting": AppIcons.menuSettings,
                    "add": AppIcons.add
                    ])
    }
    
    func layoutDidLoad(_ layoutNode: LayoutNode) {
        
        weak var `self`: AddOrEditSceneViewController! = self
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Script>>(configureCell: { ds, tv, ip, item in
            let node = tv.dequeueReusableCellNode(withIdentifier: "cell")!
            
            node.setState([
                "deviceIcon": AppIcons.devices,
                "row": ip.row
                ])
            return node.view as! UITableViewCell
        })
        Observable.of([])
            .map { (scripts) -> [SectionModel<String, Script>] in
                [
                    SectionModel(model: "设置条件", items: scripts),
                    SectionModel(model: "执行动作", items: scripts)
                ]
            }
            .bind(to: (self.tableView!.rx.items(dataSource: dataSource)))
            .disposed(by: disposeBag)
    }
}

extension AddOrEditSceneViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let node = tableView.dequeueReusableHeaderFooterNode(withIdentifier: "sectionHeader")
        let vc = SelectDeviceViewController()
        vc.type = SceneSectionType(rawValue: section) ?? .events
        weak var `self`: AddOrEditSceneViewController! = self
        node?.setState([
            "sectionType": section,
            "sectionDelegate": self
            ])
        return node?.view
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

extension AddOrEditSceneViewController: SceneSectionHeaderDelegate {
    func addButtonClick(type: SceneSectionType) {
        let vc = SelectDeviceViewController()
        vc.type = type
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension AddOrEditSceneViewController: SelectDeviceForSceneDelegate {
    func handleSelection(deviceCapability: DeviceCapability, type: SceneSectionType) {
        switch type {
        case .actions:
            break
        case .events:
            break
        }
    }
}
