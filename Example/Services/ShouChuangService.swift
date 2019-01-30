//
//  ShouchuangService.swift
//  Example
//
//  Created by 王芃 on 2019/1/21.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import ObjectMapper
import RxSwift
import Disk

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
    let client = container.resolve(HttpClient.self)!
    let baseUrl = AppEnv.apiBaseUrl
    let loading = BehaviorSubject<Bool>(value: false)
    var smartApi: SmartApiType {
        get { return .register }
    }
    
    func request() -> Observable<T> {
        var urlComponents = URLComponents(string: "\(baseUrl)\(smartApi.entityPath)")!
        let queries = try? urlQueries()
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]
        let appData = try? Disk.retrieve(Constants.APP_DATA_PATH, from: .documents, as: AppData.self)
        let requireQueries = [
            URLQueryItem(name: "p1", value: appData?.token),
            URLQueryItem(name: "apptype", value: "1")]
        urlComponents.queryItems = queries != nil ? requireQueries + queries! : requireQueries
        loading.onNext(true)
        return self.client
            .requestJson(url: urlComponents.url!, method: .post, httpHeaders: headers)
            .map({ (json) -> T in
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
            
        })
            .catchError{ (err) in
                throw handleError(err)
            }.do(onCompleted: {
                self.loading.onNext(false)
            })
        
    }
    
    func urlQueries() throws -> [URLQueryItem] {
        return []
    }
}
