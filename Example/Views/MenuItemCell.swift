//
//  MenuCell.swift
//  Example
//
//  Created by 王芃 on 2018/11/14.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import UIKit

class MenuItemCell: BaseItemCell {

    var menuItem: MenuItem? {
        didSet {
            guard let menuItem = menuItem else { return }
            initControls(menuItem: menuItem)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func initialize() {
    }
    
    
    private func initControls(menuItem: MenuItem) {
        
    }
}
