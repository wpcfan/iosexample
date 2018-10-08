//
//  AppEnv.swift
//  Example
//
//  Created by 王芃 on 2018/9/28.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import Foundation

struct AppEnv {
    static let appEnv: Dictionary<String, Any> = Bundle.main.infoDictionary!["APP_ENV"] as! Dictionary
    static let apiBaseUrl: String = appEnv["API_BASE_URL"] as! String
    static let swiftyBeaver: Dictionary<String, String> = appEnv["SWIFTY_BEAVER"] as! Dictionary
    static let swiftyBeaverAppId = swiftyBeaver["APP_ID"]!
    static let swiftyBeaverAppSecret = swiftyBeaver["APP_SECRET"]!
    static let swiftyBeaverEncryptionKey = swiftyBeaver["ENCRYPTION_KEY"]!
    static let auth: Dictionary<String, String> = appEnv["AUTH"] as! Dictionary
    static let authBaseUrl = auth["BASE_URL"]!
    static let authRealm = auth["REALM"]!
    static let authGrantType = auth["GRANT_TYPE"]!
    static let authClientId = auth["CLIENT_ID"]!
    static let authClientSecret = auth["CLIENT_SECRET"]!
    static let authOpenIdUrlTemplate = auth["OPENID_URL_TEMPLATE"]!
    static let authOpenIdBaseUrl = String(format: authOpenIdUrlTemplate, authBaseUrl, authRealm)
    static let authOpenIdAuthorizeUrl = authOpenIdBaseUrl + "/auth"
    static let authOpenIdTokenUrl = authOpenIdBaseUrl + "/token"
//    static let urlTypes = Bundle.main.infoDictionary!["CFBundleURLTypes"]
//    static let urlScheme: String = (urlTypes![1] as Dictionary)["CFBundleURLSchemes"]![0]
}
