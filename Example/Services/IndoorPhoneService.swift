//
//  IndoorPhoneService.swift
//  Example
//
//  Created by 王芃 on 2018/11/13.
//  Copyright © 2018 twigcodes. All rights reserved.
//

class IndoorPhoneService {
    func initVideo() -> Void {
        #if TARGET_CPU_ARM
        DongDongManager.share()?.initVideo()
        #endif
    }
    
    func startVideo(_ with: UIView, remoteIp: String, remotePort: Int, localPort: Int) -> Void {
        #if TARGET_CPU_ARM
        DongDongManager.share()?.startVideo(with: with, remoteIp: remoteIp, remotePort: remotePort, localPort: localPort)
        #endif
    }
    
    func stopVideo() -> Void {
        #if TARGET_CPU_ARM
        DongDongManager.share()?.stopVideo()
        #endif
    }
}
