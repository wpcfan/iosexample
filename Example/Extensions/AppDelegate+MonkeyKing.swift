//
//  AppDelegate+MonkeyKing.swift
//  Example
//
//  Created by 王芃 on 2019/1/21.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import UIKit
import MonkeyKing

// For RootViewController Navigation
extension AppDelegate {
    func setupSocial() -> Void {
        MonkeyKing.registerAccount(.weChat(appID: AppEnv.socialWeChatAppKey, appKey: AppEnv.socialWeChatAppSecret, miniAppID: nil))
    }
}
