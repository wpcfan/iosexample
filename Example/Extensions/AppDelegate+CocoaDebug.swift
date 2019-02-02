//
//  AppDelegate+CocoaDebug.swift
//  Example
//
//  Created by 王芃 on 2018/11/2.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import UIKit.UIColor

#if DEBUG
import CocoaDebug
#endif

extension AppDelegate {
    func setupDebug() {
        #if DEBUG
        CocoaDebug.serverURL = "twigcodes.com" //default value is `nil`
        //        CocoaDebug.ignoredURLs = nil //default value is `nil`
        //        CocoaDebug.onlyURLs = nil //default value is `nil`
        //        CocoaDebug.tabBarControllers = [UIViewController(), UIViewController()] //default value is `nil`
        CocoaDebug.logMaxCount = 1000 //default value is `500`
        CocoaDebug.emailToRecipients = ["wpcfan@163.com"] //default value is `nil`
        //        CocoaDebug.emailCcRecipients = ["ccc@gmail.com", "ddd@gmail.com"] //default value is `nil`
        CocoaDebug.mainColor = "#fd9727" //default value is `#42d459`
        CocoaDebug.enable()
        #endif
    }
}
