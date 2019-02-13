//
//  LeChangeService.swift
//  Example
//
//  Created by 王芃 on 2019/1/14.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import Foundation

class LeChangeService {
    public func initLeChange() -> Void {
        print("enter initLeChange")
        #if !targetEnvironment(simulator)
        var api: LCOpenSDK_Api? = nil
        let certPath = Bundle.main.path(forResource: "cert", ofType: "pem")
        api = LCOpenSDK_Api(openApi: AppEnv.apiBaseUrl, port: 443, ca_PATH: certPath)

        #endif
        print("exit initLeChange")
    }
    
    public func configWiFi() -> Void {
        print("enter configWiFi")
        #if !targetEnvironment(simulator)
        var api: LCOpenSDK_ConfigWIfi? = nil
        api = LCOpenSDK_ConfigWIfi()
        #endif
        print("exit configWiFi")
    }
}
