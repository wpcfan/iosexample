//
//  AppDelegate+Bugly.swift
//  Example
//
//  Created by 王芃 on 2018/11/11.
//  Copyright © 2018 twigcodes. All rights reserved.
//

extension AppDelegate {
    func setupBugly() -> Void {
        let config = BuglyConfig()
        // 设置自定义日志上报的级别，默认不上报自定义日志
        #if DEBUG
        config.debugMode = true
        config.reportLogLevel = .debug
        #else
        config.reportLogLevel = .error
        #endif
        
        Bugly.start(withAppId: AppEnv.buglyAppId, config:config)
    }
}
