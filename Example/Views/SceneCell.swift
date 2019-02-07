//
//  SceneCell.swift
//  Example
//
//  Created by 王芃 on 2018/10/22.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import ReactorKit
import PinLayout

class SceneCell: BaseTableCell, ReactorKit.View {
    
    typealias Reactor = SceneViewReactor
    
    var scene: Scene? {
        didSet {
            guard let scene = scene else { return }
            sceneLabel.text = scene.name
            switch scene.sceneIcon! {
            case .goHome:
                sceneIcon.image = AppIcons.sceneHomeAccent
            case .leaveHome:
                sceneIcon.image = AppIcons.sceneWorkAccent
            default:
                sceneIcon.image = AppIcons.scenePlaceholderAccent
            }
        }
    }
    
    private var sceneIcon = UIImageView()
    private var sceneLabel = UILabel()
    
    override func initialize() {
        contentView.addSubview(sceneIcon)
        contentView.addSubview(sceneLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.sizeToFit()
        sceneIcon.pin.left().vCenter().width(48)
        sceneLabel.pin.after(of: sceneIcon, aligned: .center).height(20).marginLeft(16)
    }
    
    func bind(reactor: Reactor) {
        
    }
}
