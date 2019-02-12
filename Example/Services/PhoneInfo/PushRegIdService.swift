//
//  RegisterService.swift
//  Example
//
//  Created by 王芃 on 2019/1/25.
//  Copyright © 2019 twigcodes. All rights reserved.
//
import Disk
import Device_swift
import RxSwift

class PushRegIdService: ShouChuangService<EmptyResult> {
    override var smartApi: SmartApiType {
        get { return .reportPushRegId }
    }
    override func urlQueries() -> [URLQueryItem]  {
        
        let appData = try? Disk.retrieve(Constants.APP_DATA_PATH, from: .documents, as: AppData.self)
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "pushtoken", value: appData?.regId),
            URLQueryItem(name: "uid", value: appData?.user?.id)
        ]
        return queryItems
    }
}
