//
//  JdSmartCloudService.swift
//  Example
//
//  Created by 王芃 on 2018/11/12.
//  Copyright © 2018 twigcodes. All rights reserved.
//
#if TARGET_CPU_ARM
import SCMSDK

class JdSmartCloudServiceImpl {
    public func initSmartCloud() {
        log.debug("enter initSmartCloud")
        let appKey = AppEnv.smartCloudAppKey
        log.debug(appKey)
        SCMInitManager.sharedInstance().registerAppKey(appKey)
        SCMInitManager.sharedInstance().startLoop()
        log.debug("exit initSmartCloud")
    }
    
    public func initLongPolling(userToken: String) {
        log.debug("enter initLongPolling")
        if (SCMLongConnectManager.shared().isConnecting()) {
            SCMLongConnectManager.shared().cutOffLongConnect()
        }
        SCMInitManager.sharedInstance().registerUserToken(userToken)
        SCMLongConnectManager.shared().createLongConnect()
        log.debug("exit initLongPolling")
    }
    
    public func getScenes(page: Int, pageSize: Int? = 30, extend: [AnyHashable : Any]? = nil) {
        log.debug("enter getScenes")
        SCMIFTTTManager.getIFTTTList(page, pageSize: pageSize!, extend: extend) { (dict) in
            let result = dict! as NSDictionary
            log.debug(result["status"] ?? "Not Returning Status Value")
        }
        log.debug("exit getScenes")
    }
}
#endif
