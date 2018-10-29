//
//  LinedButton.swift
//  Example
//
//  Created by 王芃 on 2018/10/28.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import UIKit

class HomeTitleView: BaseView {
    
    @objc var titleAlpha: CGFloat = 0 {
        didSet {
            layoutNode?.setState(["titleAlpha": titleAlpha])
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.loadLayout(
            named: "HomeTitleView.xml",
            state: [
                "titleAlpha": titleAlpha
            ]
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
