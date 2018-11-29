//
//  HomeTabBarViewController.swift
//  Example
//
//  Created by 王芃 on 2018/11/28.
//  Copyright © 2018 twigcodes. All rights reserved.
//
import Layout

class HomeTabBarViewController: BaseViewController, StackContainable, LayoutLoading {
    let toolbarHeight: CGFloat = 64.0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLayout(named: "HomeTabBarViewController.xml", state: [
            "toolbarHeight": toolbarHeight,
            "toolbarWidth": 0.6
            ])
    }
    
    public func preferredAppearanceInStack() -> ScrollingStackController.ItemAppearance {
        return .view(height: toolbarHeight)
    }
}
