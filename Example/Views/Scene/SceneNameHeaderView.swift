//
//  SceneNameHeaderView.swift
//  Example
//
//  Created by 王芃 on 2019/3/1.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import Layout
import RxSwift
import RxCocoa

class SceneNameHeaderView: BaseView {
    @objc var sceneName: String? = "未命名" {
        didSet {
            layoutNode?.setState(["sceneName": sceneName])
        }
    }
    @objc var sceneActive: Bool = true {
        didSet {
            layoutNode?.setState(["sceneActive": sceneActive])
        }
    }
    @objc weak var sceneNameField: UITextField!
    @objc weak var sceneActiveSwitch: UISwitch!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadLayout(named: "SceneNameHeaderView.xml", state: [
            "sceneName": sceneName!,
            "sceneActive": sceneActive])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Reactive where Base: SceneNameHeaderView {
    var sceneName: ControlProperty<String?> {
        return base.sceneNameField.rx.text
    }
    var sceneActive: ControlProperty<Bool> {
        return base.sceneActiveSwitch.rx.value
    }
}
