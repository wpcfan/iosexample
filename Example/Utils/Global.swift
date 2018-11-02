//
//  AppInitializer.swift
//  Example
//
//  Created by 王芃 on 2018/11/2.
//  Copyright © 2018 twigcodes. All rights reserved.
//
import Swinject
import JustLog
import p2_OAuth2
import Moya
import URLNavigator
import Shallows

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
