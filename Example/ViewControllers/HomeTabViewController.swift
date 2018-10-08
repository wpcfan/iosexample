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
import SwiftIconFont

class MainNavigationController: UINavigationController { }

class HomeTabViewController: UIViewController, UITabBarControllerDelegate, LayoutLoading {
    
    private var selectedTab = 0
    @objc var tabNode: UITabBarController? // outlet
    
    init(tabName: String) {
        super.init(nibName: nil, bundle: nil)
        if (tabName == "email") {
            selectedTab = 2
        } else if (tabName == "app") {
            selectedTab = 1
        } else {
            selectedTab = 0
        }
        
    }
    
    // Make the Status Bar Light/Dark Content for this View
//    override var preferredStatusBarStyle : UIStatusBarStyle {
//        return UIStatusBarStyle.lightContent
//        //return UIStatusBarStyle.default   // Make dark again
//    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.setNeedsStatusBarAppearanceUpdate()
        // Do any additional setup after loading the view, typically from a nib.
        // Swift 3.x compatibility
        #if swift(>=4.2)
        let foregroundColorKey = NSAttributedString.Key.foregroundColor
        let fontKey = NSAttributedString.Key.font
        #elseif swift(>=4)
        let foregroundColorKey = NSAttributedStringKey.foregroundColor
        let fontKey = NSAttributedStringKey.font
        #else
        let foregroundColorKey = NSForegroundColorAttributeName
        let fontKey = NSFontAttributeName
        #endif
        loadLayout(
            named: "HomeTabViewController.xml",
            state: [
                "selectedTab": selectedTab
            ],
            constants: [
                // Used in boxes, table and collection examples
                "colors": [
                    "red": UIColor(hexString: "#f66"),
                    "orange": UIColor(hexString: "#fa7"),
                    "blue": UIColor(hexString: "#09f"),
                    "green": UIColor(hexString: "#0f9"),
                    "pink": UIColor(hexString: "#fcc"),
                ],
                // Used in text example
                "attributedString": NSAttributedString(
                    string: "\u{2103}",
                    attributes: [foregroundColorKey: UIColor.red, fontKey: UIFont.systemFont(ofSize: 12)]
                ),
                "temperatureString": NSAttributedString(
                    string: "\u{2103}",
                    attributes: [foregroundColorKey: UIColor.white, fontKey: UIFont.systemFont(ofSize: 12)]
                ),
                "percentageString": NSAttributedString(
                    string: "%",
                    attributes: [foregroundColorKey: UIColor.white, fontKey: UIFont.systemFont(ofSize: 12)]
                ),
                "uppercased": { (args: [Any]) throws -> Any in
                    guard let string = args.first as? String else {
                        throw LayoutError.message("uppercased() function expects a String argument")
                    }
                    return string.uppercased()
                },
                "iconTabHome": UIImage(
                    from: .fontAwesome,
                    code: "home",
                    textColor: .black,
                    backgroundColor: .clear,
                    size: CGSize(width: 48, height: 48)),
                "iconTabSocial": UIImage(
                    from: .fontAwesome,
                    code: "comments",
                    textColor: .black,
                    backgroundColor: .clear,
                    size: CGSize(width: 48, height: 48)),
                "iconTabMe": UIImage(
                    from: .fontAwesome,
                    code: "user",
                    textColor: .black,
                    backgroundColor: .clear,
                    size: CGSize(width: 48, height: 48))
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
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let index = tabBarController.viewControllers?.index(of: viewController) else {
            return
        }
        selectedTab = index
    }
    
}
