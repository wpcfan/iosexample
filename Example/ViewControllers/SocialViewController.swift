//
//  SocialViewController.swift
//  Example
//
//  Created by 王芃 on 2018/10/1.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

class SocialViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = TabTableViewController1().then {
            $0.pageIndex = 0
        }
        let vc2 = TabTableViewController1().then {
            $0.pageIndex = 1
        }
        
        let topTabItems = [
            TopTabItem(index: 0, title: "tab1", viewController: vc1),
            TopTabItem(index: 1, title: "tab2", viewController: vc2)
        ]
        let topTabController = TopTabController(topTabItems)
        addChild(topTabController)
        self.view.addSubview(topTabController.view)
        topTabController.didMove(toParent: self)
    }
}
