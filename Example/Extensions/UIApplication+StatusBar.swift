//
//  UIApplication+StatusBar.swift
//  Example
//
//  Created by 王芃 on 2018/10/25.
//  Copyright © 2018 twigcodes. All rights reserved.
//
import UIKit

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}
