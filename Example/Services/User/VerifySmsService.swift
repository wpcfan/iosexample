//
//  VerifySmsService.swift
//  Example
//
//  Created by 王芃 on 2019/2/12.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import Disk
import Device_swift
import RxSwift

class VerifySmsService: ShouChuangService<EmptyResult> {
    var phone: String?
    var code: String?
    override var smartApi: SmartApiType {
        get { return .verifySmsCode }
    }
    override func urlQueries() -> [URLQueryItem]  {
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "phone", value: phone),
            URLQueryItem(name: "code", value: code)
        ]
        return queryItems
    }
}
