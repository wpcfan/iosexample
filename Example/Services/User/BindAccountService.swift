//
//  LoginService.swift
//  Example
//
//  Created by 王芃 on 2019/1/25.
//  Copyright © 2019 twigcodes. All rights reserved.
//

class BindAccountService: ShouChuangService<SmartUser> {
    var code: String?
    override var smartApi: SmartApiType {
        get { return .bindJdAccount }
    }
    
    override func urlQueries() throws -> [URLQueryItem] {
        guard let code = code else { throw AppErr.requiredParamNull("BindAccountService Params Null") }
        let data = DiskUtil.getData()
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "uid", value: data?.user?.id),
            URLQueryItem(name: "type", value: "\(data?.user?.type ?? 0)"),
            URLQueryItem(name: "code", value: code),
            ]
        return queryItems
    }
}
