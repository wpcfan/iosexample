//
//  AppEnv.swift
//  Example
//
//  Created by 王芃 on 2018/9/28.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

struct AppEnv {
    static let appEnv: Dictionary<String, Any> = Bundle.main.infoDictionary!["APP_ENV"] as! Dictionary
    static let apiBaseUrl: String = appEnv["API_BASE_URL"] as! String
    static let logz: Dictionary<String, String> = appEnv["LOGZ"] as! Dictionary
    static let logzPort = UInt16(logz["PORT"]!)!
    static let logzHost = logz["HOST"]!
    static let logzToken = logz["TOKEN"]!
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
    static let push: Dictionary<String, String> = appEnv["JPUSH"] as! Dictionary
    static let pushKey = push["APP_KEY"]!
    static let pushSecret = push["APP_SECRET"]!
    static let umengAppId: String = appEnv["UMENG_APPID"] as! String
    static let buglyAppId: String = appEnv["BUGLY_APPID"] as! String
    static let smartCloud: Dictionary<String, String> = appEnv["SMART_CLOUD"] as! Dictionary
    static let smartCloudAppKey = smartCloud["APP_KEY"]!
    static let smartCloudAppSecret = smartCloud["APP_SECRET"]!
    static let leChange: Dictionary<String, String> = appEnv["LECHANGE"] as! Dictionary
    static let leChangeApiUrl = leChange["API_URL"]!
    static let leChangeAppId = leChange["APP_ID"]!
    static let leChangeAppSecret = leChange["APP_SECRET"]!
    static let leanCloud: Dictionary<String, String> = appEnv["LEANCLOUD"] as! Dictionary
    static let leanCloudApiUrl = leanCloud["API_URL"]!
    static let leanCloudAppId = leanCloud["APP_ID"]!
    static let leanCloudAppSecret = leanCloud["APP_SECRET"]!
    static let social: Dictionary<String, String> = appEnv["SOCIAL"] as! Dictionary
    static let socialWeChatAppKey = social["WECHAT_APP_KEY"]!
    static let socialWeChatAppSecret = social["WECHAT_APP_SECRET"]!
    static let socialQQAppKey = social["QQ_APP_KEY"]!
    static let socialWeiBoAppKey = social["WEIBO_APP_KEY"]!
    static let socialWeiBoAppSecret = social["WEIBO_APP_SECRET"]!
    static let socialDingTalkAppKey = social["DINGTALK_APP_KEY"]!
    static let socialAliPayAppKey = social["ALIPAY_APP_KEY"]!
    static let appVersion:String = Bundle.main.infoDictionary![kCFBundleVersionKey as String] as! String
//    static let urlTypes = Bundle.main.infoDictionary!["CFBundleURLTypes"]
//    static let urlScheme: String = (urlTypes![1] as Dictionary)["CFBundleURLSchemes"]![0]
}
