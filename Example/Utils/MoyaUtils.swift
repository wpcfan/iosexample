//
//  MoyaUtils.swift
//  Example
//
//  Created by 王芃 on 2018/10/11.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import Moya
import p2_OAuth2

struct MoyaUtils {
    
    static let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
        let oauth2 = container.resolve(OAuth2PasswordGrant.self)!
        let request = try! endpoint.urlRequest() // This is the request Moya generates
        var req = oauth2.request(forURL: request.url!)
        done(.success(req))
    }
    
    static let networkPlugin = NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)
    
    private static func JSONResponseDataFormatter(_ data: Data) -> Data {
        do {
            let dataAsJSON = try JSONSerialization.jsonObject(with: data)
            let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
            return prettyData
        } catch {
            return data //fallback to original data if it cant be serialized
        }
    }
}
