//
//  TabButton.swift
//  Example
//
//  Created by 王芃 on 2018/10/28.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import UIKit

class TabButton: BaseView {
    
    @objc var title: String = "hello" {
        didSet {
            layoutNode?.setState(["title": title])
        }
    }
    @objc var color: UIColor = UIColor.accent! {
        didSet {
            layoutNode?.setState(["color": color])
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.loadLayout(
            named: "TabButton.xml",
            state: [
                "title": title,
                "color": color
            ]
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
