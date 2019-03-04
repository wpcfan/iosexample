//
//  SceneFormSectionHeader.swift
//  Example
//
//  Created by 王芃 on 2019/3/1.
//  Copyright © 2019 twigcodes. All rights reserved.
//
import Layout
import RxCocoa
import RxSwift

@objc enum SceneSectionType: Int {
    case events
    case actions
}

@objc protocol SceneSectionHeaderDelegate {
    func addButtonClick(type: SceneSectionType)
}

class SceneSectionHeader: BaseView {
    @objc var sectionType: SceneSectionType = .events {
        didSet {
            layoutNode?.setState([
                "sectionName": sectionType == .events ? "设置条件" : "设置动作"
                ])
        }
    }
    @objc weak var delegate: SceneSectionHeaderDelegate?
    @objc weak var leftBadgeView: UIView!
    @objc weak var addButton: UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadLayout(named: "SceneSectionHeader.xml",
                   state: [
                    "sectionName": ""],
                   constants: [
                    "circle": AppIcons.circle,
                    "setting": AppIcons.menuSettings,
                    "add": AppIcons.add,
                    ])
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        leftBadgeView.roundCorners(
            corners: [.topRight, .bottomRight],
            radius: 0.5 * leftBadgeView.height)
    }
    @objc func add() {
        delegate!.addButtonClick(type: sectionType)
    }
}
