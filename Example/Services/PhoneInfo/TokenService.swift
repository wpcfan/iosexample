//
//  RegisterService.swift
//  Example
//
//  Created by 王芃 on 2019/1/25.
//  Copyright © 2019 twigcodes. All rights reserved.
//
import Device_swift
import RxSwift

class TokenService: ShouChuangService<TokenInfo> {
    override var smartApi: SmartApiType {
        get { return .register }
    }
    override func urlQueries() -> [URLQueryItem]  {
        let version = AppEnv.appVersion
        let systemName = "iphone"
        let systemVersion = UIDevice.current.systemVersion
        let screenSize: String = "\(UIScreen.main.bounds.width)x\(UIScreen.main.bounds.height)"
        let idfaStr = ""
        let appendStr = "\("sc")\(version)\(systemName)\(systemVersion)\(screenSize)\(idfaStr)\("jdok")"
        let md5AppendStr = appendStr.MD5
        let deviceType = UIDevice.current.deviceType
        let appData = DiskUtil.getData()
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "a", value: version),
            URLQueryItem(name: "b", value: systemName),
            URLQueryItem(name: "c", value: systemVersion),
            URLQueryItem(name: "d", value: screenSize),
            URLQueryItem(name: "e", value: idfaStr),
            URLQueryItem(name: "f", value: md5AppendStr),
            URLQueryItem(name: "g", value: "AppStore"),
            URLQueryItem(name: "h", value: ""),
            URLQueryItem(name: "k", value: "\(deviceType)"),
            URLQueryItem(name: "i", value: appData?.projectId),
            URLQueryItem(name: "j", value: appData?.user?.id)
        ]
        return queryItems
    }
    
    func handleTokenInfo() -> Observable<TokenInfo> {
        return self.request()
            .do(onNext: { (tokenInfo) in
                DiskUtil.saveTokenInfo(tokenInfo: tokenInfo)
            })
    }
}
