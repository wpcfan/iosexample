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

class HomeTabViewController: BaseViewController {
    
    private var selectedTab = 0
    
    init(tabName: String) {
        super.init()
        if (tabName == "me") {
            selectedTab = 2
        } else if (tabName == "social") {
            selectedTab = 1
        } else {
            selectedTab = 0
        }
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLayout(
            named: "HomeTabViewController.xml",
            state: [
                "selectedTab": selectedTab,
                "isHomeBarTranslucent": true,
                "homeBarTintColor": UIColor.white,
                "isLightStyle": false,
                "homeTintColor": UIColor.white,
            ],
            constants: [
                "uppercased": AppLayoutClousures.upperCase,
                "iconTabHome": AppIcons.home,
                "iconTabSocial": AppIcons.social,
                "iconTabMy": AppIcons.user,
                "iconAdd": AppIcons.add,
                "iconSettings": AppIcons.settingsAccent,
                "emptyImage": UIImage(),
            ]
        )
    }
    
    func layoutDidLoad(_ layoutNode: LayoutNode) {
        guard let tabBarController = layoutNode.viewController as? UITabBarController else {
            return
        }
        
        tabBarController.selectedIndex = selectedTab
        tabBarController.delegate = self
    }
}
