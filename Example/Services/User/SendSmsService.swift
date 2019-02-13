//
//  SendSmsService.swift
//  Example
//
//  Created by 王芃 on 2019/2/12.
//  Copyright © 2019 twigcodes. All rights reserved.
//

class SendSmsService: ShouChuangService<EmptyResult> {
    var phone: String?
    override var smartApi: SmartApiType {
        get { return .sendSms }
    }
    override func urlQueries() -> [URLQueryItem]  {
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "phone", value: phone)
        ]
        return queryItems
    }
}
