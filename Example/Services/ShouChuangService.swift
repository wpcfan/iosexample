//
//  ShouchuangService.swift
//  Example
//
//  Created by 王芃 on 2019/1/21.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import ObjectMapper
import RxSwift
import Shallows

protocol SmartApiQuery {
    func urlQueries() throws -> [URLQueryItem]
}

enum AppErr: Error {
    case requiredParamNull(_ paramName: String?)
}

enum SmartError: Error {
    case server(_ code: Int, _ message: String)
    case tokenInvalid(_ message: String)
    case jdAccountNotBinded(_ message: String)
    case jdTokenInvalid(_ message: String)
    case loginInvalid(_ message: String)
}

class ShouChuangService<T: Mappable>: SmartApiQuery {
    private let storage = container.resolve(Storage<Filename, AppData>.self)!
    let loading = BehaviorSubject<Bool>(value: false)
    let client = container.resolve(HttpClient.self)!
    let baseUrl = AppEnv.apiBaseUrl
    var smartApi: SmartApiType {
        get { return .register }
    }
    
    func request() -> Observable<T> {
        loading.onNext(true)
        var urlComponents = URLComponents(string: "\(baseUrl)\(smartApi.entityPath)")!
        let queries = try! urlQueries()
        let appData = try! storage.makeSyncStorage().retrieve(forKey: Filename(rawValue: Constants.APP_DATA_KEY))
        let requireQueries = [URLQueryItem(name: "p1", value: appData.token), URLQueryItem(name: "apptype", value: "1")]
        urlComponents.queryItems = requireQueries + queries
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]
        return client.requestJson(url: urlComponents.url!, method: .post, httpHeaders:  headers).map({ (json) -> T in
            let item = json as! [String: Any]
            let mapped = Mapper<SmartHomeResult<T>>().map(JSON: item)!
            if((mapped.result) ?? false) {
                return mapped.data!
            } else {
                let errorCode = mapped.errorCode!
                let errorMessage = mapped.message!
                switch(errorCode) {
                case 1600:
                    throw SmartError.loginInvalid(errorMessage)
                default:
                    throw SmartError.server(mapped.errorCode!, mapped.message!)
                }
            }
            
        }).catchError{ (err) in
            throw handleError(err)
            }.do(onDispose: {
                self.loading.onNext(false)
            })
    }
    
    func urlQueries() throws -> [URLQueryItem] {
        return []
    }
}
