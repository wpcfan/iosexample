//
//  HomeBannerViewController.swift
//  Example
//
//  Created by 王芃 on 2018/11/28.
//  Copyright © 2018 twigcodes. All rights reserved.
//
import Layout

class HomeBannerViewController: BaseViewController, StackContainable, LayoutLoading {
    
    @objc var imageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        loadLayout(named: "HomeBannerViewController.xml")
    }
    
    public func preferredAppearanceInStack() -> ScrollingStackController.ItemAppearance {
        return .view(height: 200)
    }
}
