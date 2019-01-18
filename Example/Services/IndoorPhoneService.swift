//
//  IndoorPhoneService.swift
//  Example
//
//  Created by 王芃 on 2018/11/13.
//  Copyright © 2018 twigcodes. All rights reserved.
//

class IndoorPhoneService {
    func initVideo() -> Void {
        print("enter initVideo")
        #if !targetEnvironment(simulator)
        DongDongManager.share()?.initVideo()
        #endif
        print("leave initVideo")
    }
    
    func startVideo(_ with: UIView, remoteIp: String, remotePort: Int, localPort: Int) -> Void {
        print("enter startVideo")
        #if !targetEnvironment(simulator)
        DongDongManager.share()?.startVideo(with: with, remoteIp: remoteIp, remotePort: Int32(remotePort), localPort: Int32(localPort))
        #endif
        print("leave startVideo")
    }
    
    func stopVideo() -> Void {
        print("enter stopVideo")
        #if !targetEnvironment(simulator)
        DongDongManager.share()?.stopVideo()
        #endif
        print("leave stopVideo")
    }
}
