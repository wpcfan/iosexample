//  AppInitializer.swift
//  Example
//
//  Created by 王芃 on 2018/11/2.
//  Copyright © 2018 twigcodes. All rights reserved.
//
import JustLog
import p2_OAuth2
import Shallows
import Swinject
import URLNavigator
import RxSwift
#if DEBUG
    import CocoaDebug
#endif
// 全局 Observable 对象，用于多个 ViewController 中的信号共享
// 监控服务器传回的需要退出登录的信号
let NEED_LOGOUT = PublishSubject<Void>()
// 共享当前登录用户
let CURRENT_TOKEN = BehaviorSubject<String?>(value: nil)
let CURRENT_USER = BehaviorSubject<SmartUser?>(value: nil)
let CURRENT_HOUSE = BehaviorSubject<House?>(value: nil)
// 全局 log ，基于 JustLog ，但使用上通过全局的 print 和 printError 进行了封装
let log = Logger.shared
// 为 CocoaDebug 和 JustLog 提供一个统一的调用形式，Debug 模式下采用 CocoaDebug，而在 Release 模式下使用 JustLog 上传到 logz.io
public func print<T>(file: String = #file, function: String = #function, line: Int = #line, _ message: T, color: UIColor = .white) {
    #if DEBUG
        swiftLog(file, function, line, message, color, false)
    #else
        log.debug("\(message)")
    #endif
}

public func printError<T>(file: String = #file,
                          function: String = #function,
                          line: Int = #line,
                          _ message: T,
                          color: UIColor = .red) {
    #if DEBUG
        swiftLog(file, function, line, message, color, false)
    #else
        log.error("\(message)")
    #endif
}

// OAuth2 设置
let oauth2Settings = [
    "client_id": AppEnv.authClientId,
    "client_secret": AppEnv.authClientSecret,
    "authorize_uri": AppEnv.authOpenIdAuthorizeUrl,
    "token_uri": AppEnv.authOpenIdTokenUrl, // code grant only
    "redirect_uris": ["example://com.twigcodes.ios/auth"], // register your own "myapp" scheme in Info.plist
    "secret_in_body": true, // Github needs this
    "keychain": true, // if you DON'T want keychain integration
] as OAuth2JSON

// IoC 容器初始化
let container: Container = {
    let container = Container()
    container.register(Storage<Filename, AppData>.self) { _ in
        let diskStorage = DiskStorage.main.folder("appdata", in: .cachesDirectory).mapJSONObject(AppData.self)
        let storage = MemoryStorage<Filename, AppData>().combined(with: diskStorage)
        return storage
    }
    container.register(Storage<Filename, SmartUser>.self) { _ in
        let diskStorage = DiskStorage.main.folder("appdata", in: .cachesDirectory).mapJSONObject(SmartUser.self)
        let storage = MemoryStorage<Filename, SmartUser>().combined(with: diskStorage)
        return storage
    }
    container.register(OAuth2PasswordGrant.self) { _ in
        return OAuth2PasswordGrant(settings: oauth2Settings)
    }
    container.register(OAuth2Service.self) { _ in
        OAuth2Service()
    }
    container.register(NavigatorType.self) { _ in
        var navigator = Navigator()
        NavigationMap.initialize(navigator: navigator)
        return navigator
    }
    container.register(HttpClient.self) { _ in
        let plugins = [NetworkActivityIndicatorPlugin()]
        let delegate = SelfSignedSSLSessionDelegate()
        return HttpClient(sessionConfiguration: .default, requestPlugin: CompositeRequestPlugin(plugins: plugins), sessionDelegate: delegate)
    }
    container.register(SocialService.self) { _ in
        SocialService()
    }
    container.register(BannerService.self) { _ in
        BannerService()
    }
    container.register(RegisterService.self) { _ in
        RegisterService()
    }
    container.register(LoginService.self) { _ in
        LoginService()
    }
    container.register(HomeService.self) { _ in
        HomeService()
    }
    #if !targetEnvironment(simulator)
        container.register(JdSmartCloudService.self) { _ in JdSmartCloudService() }
        container.register(IndoorPhoneService.self) { _ in IndoorPhoneService() }
        container.register(LeChangeService.self) { _ in LeChangeService() }
        container.register(NotificationService.self) { _ in NotificationService() }
    #endif
    return container
}()
