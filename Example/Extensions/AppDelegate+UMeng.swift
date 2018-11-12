//
//  AppDelegate+UMeng.swift
//  Example
//
//  Created by 王芃 on 2018/11/11.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import Foundation

extension AppDelegate {
    func setupUMeng() -> Void {
        UMConfigure.initWithAppkey(AppEnv.umengAppId, channel: "appstore")
        MobClick.setScenarioType(.E_UM_NORMAL)
    }
}
