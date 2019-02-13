//
//  SetPasswordService.swift
//  Example
//
//  Created by 王芃 on 2019/2/12.
//  Copyright © 2019 twigcodes. All rights reserved.
//

class SetPasswordService: ShouChuangService<SmartUser> {
    var phone: String?
    var password: String?
    override var smartApi: SmartApiType {
        get { return .setPassword }
    }
    override func urlQueries() -> [URLQueryItem]  {
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "phone", value: phone),
            URLQueryItem(name: "pwd", value: password?.MD5.uppercased())
        ]
        return queryItems
    }
}
