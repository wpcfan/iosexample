//
//  SJUtil.swift
//  Example
//
//  Created by 王芃 on 2018/11/14.
//  Copyright © 2018 twigcodes. All rights reserved.
//

class SJUtil {
    
    /**
     * Method to get topspacing of container,
     - returns: topspace in float
     */
    static func getTopSpacing(_ viewController: UIViewController) -> CGFloat {
        
        if let _ = viewController.splitViewController {
            return 0
        }
        
        var topSpacing: CGFloat = 0.0
        let navigationController = viewController.navigationController
        
        if navigationController?.children.last == viewController {
            
            if navigationController?.isNavigationBarHidden == false {
                topSpacing = UIApplication.shared.statusBarFrame.height
                if !(navigationController?.navigationBar.isOpaque)! {
                    topSpacing += (navigationController?.navigationBar.bounds.height)!
                }
            }
        }
        
        return topSpacing
    }
    
    /**
     * Method to get bottomspacing of container
     - returns: bottomspace in float
     */
    static func getBottomSpacing(_ viewController: UIViewController) -> CGFloat {
        
        var bottomSpacing: CGFloat = 0.0
        
        if let tabBarController = viewController.tabBarController {
            if !tabBarController.tabBar.isHidden && !tabBarController.tabBar.isOpaque {
                bottomSpacing += tabBarController.tabBar.bounds.size.height
            }
        }
        
        return bottomSpacing
    }
}

extension String {
    
    func widthWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.width
    }
}
