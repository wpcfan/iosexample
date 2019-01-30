//
//  UINavigationController+Bar.swift
//  Example
//
//  Created by 王芃 on 2018/10/5.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    public func presentTransparentNavigationBar(light: Bool = false) {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.isTranslucent = true
        navigationBar.shadowImage = UIImage()
        let color = light ? UIColor.white : UIColor.black
        navigationBar.tintColor = color
        setNavigationBarHidden(false, animated:true)
    }
    
    public func hideTransparentNavigationBar() {
        setNavigationBarHidden(true, animated:false)
        navigationBar.setBackgroundImage(UINavigationBar.appearance().backgroundImage(for: UIBarMetrics.default), for:.default)
        navigationBar.isTranslucent = UINavigationBar.appearance().isTranslucent
        navigationBar.shadowImage = UINavigationBar.appearance().shadowImage
    }
    
    public func presentLightNavigationBar() {
        navigationBar.barStyle = .default
        navigationBar.barTintColor = UIColor.white
        navigationBar.tintColor = UIColor.black
        navigationBar.isTranslucent = false
    }
    
    public func presentDarkNavigationBar(_ barBackgroundColor: UIColor, _ titleColor: UIColor) {
        navigationBar.barStyle = .black
        navigationBar.barTintColor = barBackgroundColor
        navigationBar.tintColor = titleColor
        navigationBar.isTranslucent = false
    }
    
    public func fadingNavigationBar(color: UIColor = UIColor.white, alpha: CGFloat) {
        UIApplication.shared.statusBarView?.backgroundColor = color.withAlphaComponent(alpha)
        navigationBar.backgroundColor = color.withAlphaComponent(alpha)
    }
    
    public func showNavigationBarShadow() {
        navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        navigationBar.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        navigationBar.layer.shadowRadius = 1.0
        navigationBar.layer.shadowOpacity = 1.0
        navigationBar.layer.masksToBounds = false
    }
    
    public func getStatusBarHeight() -> CGFloat {
        return UIApplication.shared.statusBarView?.frame.height ?? 0
    }
    
    public func getNavigationBarHeight() -> CGFloat {
        return navigationBar.frame.height
    }
}
