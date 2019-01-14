//
//  AppDelegate+LeChange.swift
//  Example
//
//  Created by 王芃 on 2018/11/13.
//  Copyright © 2018 twigcodes. All rights reserved.
//

extension AppDelegate {
    func setupLeChange() -> Void {
        #if TARGET_CPU_ARM
        let certPath = Bundle.main.path(forResource: "cert", ofType: "pem")
        LCOpenSDK_Api.init(openApi: AppEnv.apiBaseUrl, port: 443, ca_PATH: certPath)
        #endif
    }
}
