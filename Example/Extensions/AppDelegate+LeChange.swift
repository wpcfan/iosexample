//
//  AppDelegate+LeChange.swift
//  Example
//
//  Created by 王芃 on 2018/11/13.
//  Copyright © 2018 twigcodes. All rights reserved.
//

extension AppDelegate {
    func setupLeChange() -> Void {
        #if !targetEnvironment(simulator)
        let leChangeService = container.resolve(LeChangeService.self)!
        leChangeService.initLeChange()
        #endif
    }
}
