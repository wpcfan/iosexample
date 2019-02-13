//
//  UIViewController+.swift
//  Example
//
//  Created by 王芃 on 2019/1/27.
//  Copyright © 2019 twigcodes. All rights reserved.
//

extension UIViewController {
    func topMostViewController() -> UIViewController {
        
        if let presented = self.presentedViewController {
            return presented.topMostViewController()
        }
        
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController() ?? navigation
        }
        
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController() ?? tab
        }
        
        return self
    }
    func setNavigationTitle(_ title: String, titleColor: UIColor = .white) -> Void {
        let titleLabel = UILabel().then {
            $0.text = title
            $0.textColor = titleColor
            $0.sizeToFit()
        }
        self.navigationItem.titleView = titleLabel
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
}
