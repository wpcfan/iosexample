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

class SceneFormSectionHeader: BaseView {
    var addNew: (()->Void)!
    var sectionName: String? {
        didSet {
            layoutNode?.setState([
                "sectionName": sectionName ?? ""
                ])
        }
    }
    @objc weak var leftBadgeView: UIView?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadLayout(named: "SceneFormSectionHeader.xml",
                   state: [
                    "sectionName": sectionName ?? ""],
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
        
        leftBadgeView!.roundCorners(corners: [.topRight, .bottomRight], radius: 10)
    }
    @objc func add() {
        if addNew != nil {
            addNew()
        }
    }
}

