//
//  SceneNameHeaderView.swift
//  Example
//
//  Created by 王芃 on 2019/3/1.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import PinLayout

class SceneNameHeaderView: BaseView {
    var scene: HouseScene? {
        didSet {
            guard let scene = scene?.scene else { return }
            layoutNode?.setState([
                "sceneName": scene.displayName ?? "",
                "isOn": scene.scriptStatus ?? false
                ])
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadLayout(named: "SceneNameHeaderView.xml", state: [
            "sceneName": "",
            "isOn": false])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
