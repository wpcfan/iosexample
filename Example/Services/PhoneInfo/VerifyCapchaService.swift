//
//  VerifyCapchaService.swift
//  Example
//
//  Created by 王芃 on 2019/2/12.
//  Copyright © 2019 twigcodes. All rights reserved.
//

class VerifyCapchaService: ShouChuangService<EmptyResult> {
    var phone: String?
    var code: String?
    var type: String?
    override var smartApi: SmartApiType {
        get { return .verifyCaptcha }
    }
    override func urlQueries() -> [URLQueryItem]  {
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "type", value: type),
            URLQueryItem(name: "phone", value: phone),
            URLQueryItem(name: "code", value: code)
        ]
        return queryItems
    }
}