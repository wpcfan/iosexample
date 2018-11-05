//
//  AppDelegate.swift
//  Example
//
//  Created by 王芃 on 2018/9/28.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import UIKit
import URLNavigator
import RxSwift

#if swift(>=4.2)
extension UIApplication {
    typealias LaunchOptionsKey = UIApplication.LaunchOptionsKey
}
#else
extension UIApplication {
    typealias LaunchOptionsKey = UIApplicationLaunchOptionsKey
}
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var disposeBag = DisposeBag()
    var window: UIWindow?
    let navigator = container.resolve(NavigatorType.self)!
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {
        enableLogging()
        enableDebug()
        setupPushNotification(launchOptions)
        ShortcutParser.shared.registerShortcuts()
        NotificationCenter.default.rx.notification(.jPushAddNotificationCount, object: nil)
            .subscribe{ print("收到消息 \(String(describing: $0.element))") }
            .disposed(by: self.disposeBag)
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = RootViewController()
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
        ) -> Bool {
        //        if "example" == url.scheme || (url.scheme?.hasPrefix("com.twigcodes.ios"))! {
        //            oauth2.handleRedirectURL(url)
        //            return true
        //        }
        // Try presenting the URL first
        if self.navigator.present(url) != nil {
            print("[Navigator] present: \(url)")
            return true
        }
        
        // Try opening the URL
        if self.navigator.open(url) == true {
            print("[Navigator] open: \(url)")
            return true
        }
        
        return false
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        forceSendLogs(application)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        forceSendLogs(application)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        clearNotification(application)
    }
    
    // MARK: Shortcuts
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(Deeplinker.handleShortcut(item: shortcutItem))
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // handle any deeplink
        Deeplinker.checkDeepLink()
    }
}
