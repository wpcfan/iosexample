//
//  AppDelegate+Logging.swift
//  Example
//
//  Created by 王芃 on 2018/11/2.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import UIKit

extension AppDelegate {
    func enableLogging() {
        let sessionID = UUID().uuidString
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
    
    func forceSendLogs(_ application: UIApplication) {
        
        var identifier: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)
        
        identifier = application.beginBackgroundTask(expirationHandler: {
            application.endBackgroundTask(identifier)
            identifier = UIBackgroundTaskIdentifier.invalid
        })
        
        log.forceSend { completionHandler in
            application.endBackgroundTask(identifier)
            identifier = UIBackgroundTaskIdentifier.invalid
        }
    }
}
