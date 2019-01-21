//
//  AppDelegate+UMeng.swift
//  Example
//
//  Created by 王芃 on 2018/11/11.
//  Copyright © 2018 twigcodes. All rights reserved.
//

extension AppDelegate {
    func setupUMeng() -> Void {
        #if DEBUG
        UMCommonLogManager.setUp()
        UMConfigure.setLogEnabled(true)
        #endif
        UMConfigure.initWithAppkey(AppEnv.umengAppId, channel: "appstore")
        MobClick.setScenarioType(.E_UM_NORMAL)
    }
    
//    func configUShareSettings() -> Void {
//        /*
//         * 打开图片水印
//         */
//        UMSocialGlobal.shareInstance().isUsingWaterMark = true
//        /*
//         * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
//         <key>NSAppTransportSecurity</key>
//         <dict>
//         <key>NSAllowsArbitraryLoads</key>
//         <true/>
//         </dict>
//         */
//        UMSocialGlobal.shareInstance().isUsingHttpsWhenShareContent = false
//    }
//
//    func configUSharePlatforms() -> Void {
//        /* 设置微信的appKey和appSecret */
//        UMSocialManager.default()?.setPlaform(.wechatSession, appKey: AppEnv.socialWeChatAppKey, appSecret: AppEnv.socialWeChatAppSecret, redirectURL: "http://mobile.umeng.com/social")
//
//        /*
//         * 移除相应平台的分享，如微信收藏
//         */
//        //UMSocialManager.default()?.removePlatformProvider(with: .wechatFavorite)
//        /* 设置分享到QQ互联的appID
//         * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
//         */
////        UMSocialManager.default()?.setPlaform(.QQ, appKey: AppEnv.socialQQAppKey, appSecret: nil, redirectURL: "http://mobile.umeng.com/social")
//        /* 设置新浪的appKey和appSecret */
////        UMSocialManager.default()?.setPlaform(.sina, appKey: AppEnv.socialWeiBoAppKey, appSecret: AppEnv.socialWeiBoAppSecret, redirectURL: "https://sns.whalecloud.com/sina2/callback")
//        /* 钉钉的appKey */
////        UMSocialManager.default()?.setPlaform(.dingDing, appKey: AppEnv.socialDingTalkAppKey, appSecret: nil, redirectURL: nil)
//        /* 支付宝的appKey */
////        UMSocialManager.default()?.setPlaform(.alipaySession, appKey: AppEnv.socialAliPayAppKey, appSecret: nil, redirectURL: "http://mobile.umeng.com/social")
//    }
}
