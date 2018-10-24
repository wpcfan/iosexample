//
//  CustomHeaderView.swift
//  Example
//
//  Created by 王芃 on 2018/10/24.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import UIKit
import Layout
import ReactorKit

class CustomHeaderView: BaseView, LayoutLoading, View {
    
    typealias Reactor = HomeViewReactor
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadLayout(named: "CustomHeaderView.xml")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Ensure layout is updated after screen rotation, etc
        self.layoutNode?.view.frame = self.bounds
    }
    

    func bind(reactor: Reactor) {
        
    }
}
