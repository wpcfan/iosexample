//
//  JdSmartCloudService.swift
//  Example
//
//  Created by 王芃 on 2018/11/12.
//  Copyright © 2018 twigcodes. All rights reserved.
//
import SCMSDK

class JdSmartCloudService {
    public func initSmartCloud() {
        print("enter initSmartCloud")
        #if !targetEnvironment(simulator)
        let appKey = AppEnv.smartCloudAppKey
        print("[JdSmartCloudService] 为京东 SDK 设置 appkey \(appKey)")
        SCMInitManager.sharedInstance().registerAppKey(appKey)
        SCMInitManager.sharedInstance().startLoop()
        #endif
        print("exit initSmartCloud")
    }
    
    public func initLongPolling(userToken: String) {
        print("enter initLongPolling")
        #if !targetEnvironment(simulator)
        if (SCMLongConnectManager.shared().isConnecting()) {
            SCMLongConnectManager.shared().cutOffLongConnect()
        }
        SCMInitManager.sharedInstance().registerUserToken(userToken)
        SCMLongConnectManager.shared().createLongConnect()
        #endif
        print("exit initLongPolling")
    }
    
    public func getScenes(page: Int, pageSize: Int? = 30, extend: [AnyHashable : Any]? = nil) {
        print("enter getScenes")
        #if !targetEnvironment(simulator)

        SCMIFTTTManager.getIFTTTList(page, pageSize: pageSize!, extend: extend) { (dict) in
            let result = dict! as NSDictionary
            print(result["status"] ?? "Not Returning Status Value")
        }
        #endif
        print("exit getScenes")
    }
    
    public func bindJdAccount(vc: UIViewController) {
        print("enter bindJdAccount")
        #if !targetEnvironment(simulator)
        SCMAuthorizedInitManager.shared()?.showAuthorizeViewController(withRootController: vc, state: "", redirectUrl: "https://116.196.81.233")
        #endif
        print("exit bindJdAccount")
    }
}
