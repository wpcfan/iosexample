//
//  AddOrEditSceneViewController.swift
//  Example
//
//  Created by 王芃 on 2019/3/1.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import Eureka
import RxSwift

class AddOrEditSceneViewController: FormViewController {
    weak var scene: HouseScene?
    var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weak var `self`: AddOrEditSceneViewController! = self
        title = scene?.scene?.script == nil ? "新建场景" : "编辑场景"
        form +++ Section(){ section in
                var header = HeaderFooterView<SceneNameHeaderView>(.class)
                header.height = { 100 }
                header.onSetupView = { view, _ in
                    view.scene = self.scene
                    view.backgroundColor = .primary
                }
                section.header = header
            }
            +++ Section(){ section in
                var header = HeaderFooterView<SceneFormSectionHeader>(.class)
                header.height = { 50 }
                header.onSetupView = { view, _ in
                    view.sectionName = "设置条件"
                    view.backgroundColor = .white
                    view.addNew = {() -> Void in
                        self.navigationController?.pushViewController(SelectDeviceViewController(), animated: true)
                    }
                }
                section.header = header
            }
            <<< TextRow(){ row in
                row.title = "Text Row"
                row.placeholder = "Enter text here"
                }.cellSetup({ (cell, row) in
                    cell.imageView?.image = AppIcons.menuDevices
                })
            
            <<< PushRow<String>() { row in
                row.title = ""
                }.cellSetup({ (cell, row) in
                    cell.imageView?.image = AppIcons.menuDevices
                })
            
            +++ Section(){ section in
                var header = HeaderFooterView<SceneFormSectionHeader>(.class)
                header.height = { 50 }
                header.onSetupView = { view, _ in
                    view.sectionName = "执行任务"
                    view.backgroundColor = .white
                }
                section.header = header
            }
            <<< DateRow(){
                $0.title = "Date Row"
                $0.value = Date(timeIntervalSinceReferenceDate: 0)
            }
    }
}
