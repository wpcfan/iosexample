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
import SwiftyBeaver
import p2_OAuth2
import Moya
import URLNavigator
import Shallows
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

let log = SwiftyBeaver.self
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
    private var navigator: NavigatorType?
//    private let oauth2 = container.resolve(OAuth2CodeGrant.self)!
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {
        enableLogging()
        log.debug(AppEnv.authBaseUrl)
        ShortcutParser.shared.registerShortcuts()
        let navigator = Navigator()
        // Initialize navigation map
        NavigationMap.initialize(navigator: navigator)
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = RootViewController()
        window.makeKeyAndVisible()
        
        self.window = window
        self.navigator = navigator
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
        if self.navigator?.present(url, wrap: UINavigationController.self) != nil {
            log.debug("[Navigator] present: \(url)")
            return true
        }
        
        // Try opening the URL
        if self.navigator?.open(url) == true {
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
    
    fileprivate func enableLogging() {
        let console = ConsoleDestination()  // log to Xcode Console
        let appId = AppEnv.swiftyBeaverAppId
        let appSecret = AppEnv.swiftyBeaverAppSecret
        let encryptionKey = AppEnv.swiftyBeaverEncryptionKey
        let cloud = SBPlatformDestination(
            appID: appId,
            appSecret: appSecret,
            encryptionKey: encryptionKey) // to cloud
        //        console.format = "$Dyyyy-MM-dd HH:mm:ss.SSS$d $C$L$c: $M"
        // add the destinations to SwiftyBeaver
        log.addDestination(console)
        log.addDestination(cloud)
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
