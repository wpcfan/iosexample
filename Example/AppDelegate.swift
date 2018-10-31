//
//  AppDelegate.swift
//  Example
//
//  Created by 王芃 on 2018/9/28.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import UIKit
import Layout
import Swinject
import JustLog
import p2_OAuth2
import Moya
import URLNavigator
import Shallows
import RxSwift

#if DEBUG
import CocoaDebug
#endif


#if swift(>=4.2)
extension UIApplication {
    typealias LaunchOptionsKey = UIApplication.LaunchOptionsKey
}
#else
extension UIApplication {
    typealias LaunchOptionsKey = UIApplicationLaunchOptionsKey
}
#endif

let log = Logger.shared
// IoC container
let container: Container = {
    let container = Container()
    container.register(Storage<Filename, AppData>.self) { _ in
        let diskStorage = DiskStorage.main.folder("appdata", in: .cachesDirectory).mapJSONObject(AppData.self)
        let storage = MemoryStorage<Filename, AppData>().combined(with: diskStorage)
        return storage
    }
    container.register(OAuth2JSON.self) { _ in
        [
        "client_id": AppEnv.authClientId,
        "client_secret": AppEnv.authClientSecret,
        "authorize_uri": AppEnv.authOpenIdAuthorizeUrl,
        "token_uri": AppEnv.authOpenIdTokenUrl,   // code grant only
        "redirect_uris": ["example://com.twigcodes.ios/auth"],   // register your own "myapp" scheme in Info.plist
        "secret_in_body": true,    // Github needs this
        "keychain": true,         // if you DON'T want keychain integration
        ] as OAuth2JSON
    }
//    container.register(OAuth2CodeGrant.self) { c in
//        let settings = c.resolve(OAuth2JSON.self)!
//        return OAuth2CodeGrant(settings: settings)
//    }
    container.register(OAuth2PasswordGrant.self) { c in
        let settings = c.resolve(OAuth2JSON.self)!
        return OAuth2PasswordGrant(settings: settings)
    }
    container.register(OAuth2Service.self) { _ in
        OAuth2Service()
    }
    container.register(NavigatorType.self) { _ in
        var navigator = Navigator()
        NavigationMap.initialize(navigator: navigator)
        return navigator
    }
    #if TARGET_CPU_ARM
    container.register(SmartCloudService.self) { _ in SmartCloudServiceImpl() }
    #endif
    return container
}()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let disposeBag = DisposeBag()
    private var sessionID = UUID().uuidString
    private let navigator = container.resolve(NavigatorType.self)!
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {
        enableLogging()
        enableDebug()
        ShortcutParser.shared.registerShortcuts()
        
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
            log.debug("[Navigator] present: \(url)")
            return true
        }
        
        // Try opening the URL
        if self.navigator.open(url) == true {
            log.debug("[Navigator] open: \(url)")
            return true
        }
        
        return false
    }
    
    //    func applicationDidBecomeActive(_ application: UIApplication) {
    //        // handle any deeplink
    //        Deeplinker.checkDeepLink()
    //    }
    //
    //    // MARK: Shortcuts
    //    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
    //        completionHandler(Deeplinker.handleShortcut(item: shortcutItem))
    //    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        forceSendLogs(application)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        forceSendLogs(application)
    }
    
    private func forceSendLogs(_ application: UIApplication) {
        
        var identifier: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)
        
        identifier = application.beginBackgroundTask(expirationHandler: {
            application.endBackgroundTask(identifier)
            identifier = UIBackgroundTaskIdentifier.invalid
        })
        
        Logger.shared.forceSend { completionHandler in
            application.endBackgroundTask(identifier)
            identifier = UIBackgroundTaskIdentifier.invalid
        }
    }
    
    fileprivate func enableLogging() {
        
        // file destination
        log.logFilename = "example.log"
        
        // logstash destination
        log.logstashHost = AppEnv.logzHost
        log.logstashPort = AppEnv.logzPort
        log.logzioToken = AppEnv.logzToken
        log.logstashTimeout = 5
        log.logLogstashSocketActivity = true
        // default info
        log.defaultUserInfo = [
            "app": "Example",
            "environment": "development",
            "tenant": "TwigCodes",
            "session": sessionID]
        log.setup()
    }
    
    fileprivate func enableDebug() {
        #if DEBUG
        CocoaDebug.serverURL = "twigcodes.com" //default value is `nil`
//        CocoaDebug.ignoredURLs = nil //default value is `nil`
//        CocoaDebug.onlyURLs = nil //default value is `nil`
//        CocoaDebug.tabBarControllers = [UIViewController(), UIViewController()] //default value is `nil`
        CocoaDebug.recordCrash = true //default value is `false`
        CocoaDebug.logMaxCount = 1000 //default value is `500`
        CocoaDebug.emailToRecipients = ["wpcfan@163.com"] //default value is `nil`
//        CocoaDebug.emailCcRecipients = ["ccc@gmail.com", "ddd@gmail.com"] //default value is `nil`
        CocoaDebug.mainColor = "#fd9727" //default value is `#42d459`
        CocoaDebug.enable()
        #endif
    }
}

extension AppDelegate {
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    var rootViewController: RootViewController {
        return window!.rootViewController as! RootViewController
    }
}

public func print<T>(file: String = #file, function: String = #function, line: Int = #line, _ message: T, color: UIColor = .white) {
    #if DEBUG
    swiftLog(file, function, line, message, color)
    #endif
}
