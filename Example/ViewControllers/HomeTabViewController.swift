//
//  HomeViewController.swift
//  Example
//
//  Created by 王芃 on 2018/9/29.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import UIKit
import Layout
import URLNavigator

class MainNavigationController: UINavigationController { }

class HomeTabViewController: UIViewController {
    
    private var selectedTab = 0
    
    init(tabName: String) {
        super.init(nibName: nil, bundle: nil)
        if (tabName == "status") {
            selectedTab = 2
        } else if (tabName == "home") {
            selectedTab = 0
        } else {
            selectedTab = 1
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLayout(
            named: "HomeTabViewController.xml",
            state: [
                "selectedTab": selectedTab
            ],
            constants: [
                "uppercased": AppLayoutClousures.upperCase,
                "iconTabHome": AppIcons.home,
                "iconTabSocial": AppIcons.social,
                "iconTabMy": AppIcons.user,
                "iconAdd": AppIcons.add,
                "iconSettings": AppIcons.settingsAccent
                ]
        )
    }
    
}

extension HomeTabViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let index = tabBarController.viewControllers?.index(of: viewController) else {
            return
        }
        selectedTab = index
    }
}

extension HomeTabViewController: LayoutLoading {
    func layoutDidLoad(_ layoutNode: LayoutNode) {
        guard let tabBarController = layoutNode.viewController as? UITabBarController else {
            return
        }
        
        tabBarController.selectedIndex = selectedTab
        tabBarController.delegate = self
    }
}
