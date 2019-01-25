//
//  ShouchuangService.swift
//  Example
//
//  Created by 王芃 on 2019/1/21.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import ObjectMapper
import RxSwift

protocol SmartApiQuery {
    func urlQueries() -> [URLQueryItem]
}

enum SmartError: Error {
    case server(_ data: [String: Any]?)
    case tokenInvalid
    case jdAccountNotBinded
    case jdTokenInvalid
}

class ShouChuangService<T: Mappable>: SmartApiQuery {
    let loading = BehaviorSubject<Bool>(value: false)
    let client = container.resolve(HttpClient.self)!
    let baseUrl = AppEnv.apiBaseUrl
    var smartApi: SmartApiType {
        get {return .register}
    }
    
    func request() -> Observable<T> {
        loading.onNext(true)
        var urlComponents = URLComponents(string: "\(baseUrl)\(smartApi.entityPath)")!
        urlComponents.queryItems = urlQueries()
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]
        return client.requestJson(url: urlComponents.url!, method: .post, httpHeaders:  headers).map({ (json) -> T in
            let item = json as! [String: Any]
            let mapped = Mapper<SmartHomeResult<T>>().map(JSON: item)
            if((mapped?.result)!) {
                return mapped!.data!
            } else {
                throw SmartError.server(item)
            }
            
        }).catchError{ (err) in
            throw handleError(err)
            }.do(onDispose: {
                self.loading.onNext(false)
            })
    }
    
    func urlQueries() -> [URLQueryItem] {
        return []
    }
}
