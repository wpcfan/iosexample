//
//  SceneNameHeaderView.swift
//  Example
//
//  Created by 王芃 on 2019/3/1.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import Layout
import RxSwift

class SceneNameHeaderView: BaseView {
    var sceneName: String?
    var sceneActive: Bool?
    weak var scene: HouseScene? {
        didSet {
            guard let scene = scene?.scene else { return }
            layoutNode?.setState([
                "sceneName": scene.displayName ?? "",
                "isOn": scene.scriptStatus ?? true
                ])
        }
    }
    @objc weak var sceneNameField: UITextField!
    @objc weak var sceneActiveSwitch: UISwitch!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadLayout(named: "SceneNameHeaderView.xml", state: [
            "sceneName": "未命名",
            "isOn": true])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutDidLoad(_ layoutNode: LayoutNode) {
        super.layoutDidLoad(layoutNode)
        
        sceneNameField.rx.text
            .subscribe { ev in
                guard let ev = ev.element else { return }
                self.sceneName = ev
            }
            .disposed(by: disposeBag)
        
        sceneActiveSwitch.rx.value
            .subscribe { ev in
                guard let ev = ev.element else { return }
                self.sceneActive = ev
            }
            .disposed(by: disposeBag)
    }
}
