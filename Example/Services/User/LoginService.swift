//
//  LoginService.swift
//  Example
//
//  Created by 王芃 on 2019/1/25.
//  Copyright © 2019 twigcodes. All rights reserved.
//

class LoginService: ShouChuangService<SmartUser> {
    var mobile: String?
    var password: String?
    override var smartApi: SmartApiType {
        get { return .login }
    }
    
    override func urlQueries() throws -> [URLQueryItem] {
        guard let mobile = mobile, let password = password else { throw AppErr.requiredParamNull("Login Params Null") }
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "phone", value: mobile),
            URLQueryItem(name: "pwd", value: password.MD5.uppercased()),
        ]
        return queryItems
    }
}
