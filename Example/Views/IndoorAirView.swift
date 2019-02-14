//
//  IndoorAirView.swift
//  Example
//
//  Created by 王芃 on 2019/2/15.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import Layout

class IndoorAirView: BaseView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.loadLayout(named: "IndoorAirView.xml")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
