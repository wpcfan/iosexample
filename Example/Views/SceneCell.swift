//
//  SceneCell.swift
//  Example
//
//  Created by 王芃 on 2018/10/22.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import ReactorKit

class SceneCell: BaseItemCell, ReactorKit.View {
    
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
        sceneIcon.snp.makeConstraints { make in
            make.bottom.left.top.equalToSuperview()
            make.width.equalTo(48)
        }
        sceneLabel.snp.makeConstraints { make in
            make.left.equalTo(sceneIcon.snp.right).offset(16)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
        }
    }
    
    func bind(reactor: Reactor) {
        
    }
}
