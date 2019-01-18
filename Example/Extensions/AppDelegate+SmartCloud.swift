//
//  AppDelegate+JdSmartCloud.swift
//  Example
//
//  Created by 王芃 on 2018/11/12.
//  Copyright © 2018 twigcodes. All rights reserved.
//

extension AppDelegate {
    func setupJdSmartCloud() -> Void {
        #if !targetEnvironment(simulator)
        let smartCloudServie = container.resolve(JdSmartCloudService.self)!
        smartCloudServie.initSmartCloud()
        
        #endif
    }
}
