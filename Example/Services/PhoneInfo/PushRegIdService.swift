//
//  RegisterService.swift
//  Example
//
//  Created by 王芃 on 2019/1/25.
//  Copyright © 2019 twigcodes. All rights reserved.
//

class PushRegIdService: ShouChuangService<EmptyResult> {
    override var smartApi: SmartApiType {
        get { return .reportPushRegId }
    }
    override func urlQueries() -> [URLQueryItem]  {
        
        let appData = DiskUtil.getData()
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "pushtoken", value: appData?.regId),
            URLQueryItem(name: "uid", value: appData?.user?.id)
        ]
        return queryItems
    }
}
