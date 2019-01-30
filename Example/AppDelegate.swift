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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private let navigator = container.resolve(NavigatorType.self)!
    private let social = container.resolve(SocialService.self)!
    private let registerService = container.resolve(RegisterService.self)!
    private var disposeBag = DisposeBag()
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
        #if !targetEnvironment(simulator)
        clearNotification(application)
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
        let appStorage = Observable.deferred { () -> Observable<AppData> in
            let data = try Disk.retrieve(Constants.APP_DATA_PATH, from: .documents, as: AppData.self)
            return Observable.of(data)
        }
        let fromStorage: Observable<String?> = appStorage.map{ appData in
            let data = appData
            return data.token
            }
            .takeWhile { (token) -> Bool in
                token != nil
            }
            .distinctUntilChanged()
        let fromNetwork: Observable<String?> = self.registerService.request().map{ register in
            return register.token
        }.share()
        
        fromNetwork
            .filterNil()
            .map{ token -> String? in
                var data = try? Disk.retrieve(Constants.APP_DATA_PATH, from: .documents, as: AppData.self)
                if (data == nil) {
                    data = AppData(JSON: ["token": token])
                } else {
                    data!.token = token
                }
                try Disk.save(data, to: .documents, as: Constants.APP_DATA_PATH)
                return token
            }
            .subscribe{ev in
                if((ev.error) != nil) {
                    print("存储错误，\(String(describing: ev.error))")
                }
            }
            .disposed(by: self.disposeBag)
        
        Observable.concat(fromStorage, fromNetwork)
            .debug()
            .catchErrorJustReturn(nil)
            .subscribe{ ev in
                guard let token = ev.element else { return }
                CURRENT_TOKEN.onNext(token)
            }
            .disposed(by: self.disposeBag)
        
        NotificationCenter.default.rx.notification(.jPushAddNotificationCount, object: nil)
            .subscribe{ print("收到消息 \(String(describing: $0.element))") }
            .disposed(by: self.disposeBag)
    }
}
