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
import Disk
import Reachability
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private let navigator = container.resolve(NavigatorType.self)!
    private let social = container.resolve(SocialService.self)!
    private var disposeBag = DisposeBag()
    var reachability = Reachability()
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    var rootViewController: RootViewController {
        return window!.rootViewController as! RootViewController
    }
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {
        if !Disk.exists(Constants.APP_DATA_PATH, in: .documents) {
            let data = AppData(JSON: ["tourGuidePresented": false])
            try? Disk.save(data, to: .documents, as: Constants.APP_DATA_PATH)
        }
        setupLogging()
        setupDebug()
        setupBugly()
        setupUMeng()
        setupSocial()
        setupJdSmartCloud()
        setupLeChange()
        setupPushNotification(launchOptions)
        ShortcutParser.shared.registerShortcuts()
        setupGlobalObservables()
        try? reachability?.startNotifier()
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
        if(social.handleOpenURL(url: url)) {
            return true
        }
        //        if "example" == url.scheme || (url.scheme?.hasPrefix("com.twigcodes.ios"))! {
        //            oauth2.handleRedirectURL(url)
        //            return true
        //        }
        // Try presenting the URL first
        if self.navigator.present(url, wrap: UINavigationController.self) != nil {
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
        #if !targetEnvironment(simulator)
        if (DiskUtil.getData()?.houseToken == nil) {
            return
        }
        SCMInitManager.sharedInstance().stopLoop()
        #endif
    }

    func applicationWillTerminate(_ application: UIApplication) {
        forceSendLogs(application)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        #if !targetEnvironment(simulator)
        clearNotification(application)
        if (DiskUtil.getData()?.houseToken == nil) {
            return
        }
        SCMInitManager.sharedInstance().startLoop()
        #endif
    }

    // MARK: Shortcuts
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(Deeplinker.handleShortcut(item: shortcutItem))
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // handle any deeplink
        Deeplinker.checkDeepLink()
    }
    
    fileprivate func setupGlobalObservables() {
        NotificationCenter.default.rx.notification(.jPushAddNotificationCount, object: nil)
            .subscribe{ print("收到消息 \(String(describing: $0.element))") }
            .disposed(by: self.disposeBag)
    }
}
