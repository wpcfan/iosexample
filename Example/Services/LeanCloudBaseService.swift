//
//  LeanCloudBaseService.swift
//  Example
//
//  Created by 王芃 on 2019/1/19.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import ObjectMapper
import CommonCrypto
import RxSwift

class LeanCloudBaseService<T>: Crudable where T: Mappable {
    
    private var reqHeaders: [String: String] {
        get {
            let now = String(describing: Date().toMillis()!)
            print("timestamp is \(now)")
            let toBeHashed = "\(now)\(AppEnv.leanCloudAppSecret)"
            print("string to be hashed \(toBeHashed)")
            let sign = toBeHashed.MD5
            return ["X-LC-Id": AppEnv.leanCloudAppId, "X-LC-Sign": "\(sign),\(now)"]
        }
        set {}
    }
    
    let loading = BehaviorSubject<Bool>(value: false)
    var baseUrl: String =  "\(AppEnv.leanCloudApiUrl)/classes"
    var entityPath: String = ""
    let client = container.resolve(HttpClient.self)!
    
    func getBy(_ id: String) -> Observable<T> {
        loading.onNext(true)
        let url = URL(string: "\(baseUrl)/\(entityPath)/\(id)")!
        return client.requestJson(url: url, httpHeaders: reqHeaders).map{ (json) -> T in
            let item = json as! [String: Any]
            let entity = Mapper<T>().map(JSON: item)!
            return entity
            }
            .retry(3)
            .catchError{ (err) in
                throw self.handleError(err)
            }
            .do(onCompleted: {
                self.loading.onNext(false)
            })
    }
    
    func getAll() -> Observable<[T]> {
        loading.onNext(true)
        let url = URL(string: "\(baseUrl)/\(entityPath)")!
        let req = URLRequest(url: url, headers: self.reqHeaders)
        return client.requestJson(req).map{ (json) -> [T] in
            let res = json as! [String: Any]
            let collection = Mapper<LeanCloudCollection<T>>().map(JSON: res)!
            return collection.results
            }.retry(3)
            .catchError{ (err) in
                throw self.handleError(err)
            }.do(onCompleted: {
                self.loading.onNext(false)
            })
    }
    
    func page(skip: Int, limit: Int, sort: String, filter: String) -> Observable<[T]> {
        loading.onNext(true)
        let url = URL(string: "\(baseUrl)/\(entityPath)")!
        let req = URLRequest(url: url, headers: self.reqHeaders)
        return client.requestJson(req).map{ (json) -> [T] in
            let res = json as! [String: Any]
            let collection = Mapper<LeanCloudCollection<T>>().map(JSON: res)!
            return collection.results
            }.retry(3)
            .catchError{ (err) in
                throw self.handleError(err)
            }.do(onCompleted: {
                self.loading.onNext(false)
            })
    }
    
    func add(_ entity: T) -> Observable<T> {
        loading.onNext(true)
        let url = URL(string: "\(baseUrl)/\(entityPath)")!
        let headers = reqHeaders.merging(["Content-Type": "application/json"]) { (curr, new) -> String in
            new
        }
        return client.requestJson(url: url, method: .post, jsonBody: entity.toJSON(), options: [], httpHeaders:  headers).map({ (json) -> T in
            let item = json as! [String: Any]
            let newEntity = entity.toJSON().merging(item, uniquingKeysWith: { (curr, new) -> Any in
                new
            })
            let newItem = Mapper<T>().map(JSON: newEntity)!
            return newItem
        }).catchError{ (err) in
            throw self.handleError(err)
            }.do(onDispose: {
                self.loading.onNext(false)
            })
    }
    
    func update(_ id: String, _ changes: T) -> Observable<T> {
        loading.onNext(true)
        let url = URL(string: "\(baseUrl)/\(entityPath)/\(id)")!
        let headers = reqHeaders.merging(["Content-Type": "application/json"]) { (curr, new) -> String in
            new
        }
        return client.requestJson(url: url, method: .put, jsonBody: changes.toJSON(), options: [], httpHeaders: headers).map({ (json) -> T in
            let item = json as! [String: Any]
            let newEntity = changes.toJSON().merging(item, uniquingKeysWith: { (curr, new) -> Any in
                new
            })
            let newItem = Mapper<T>().map(JSON: newEntity)!
            return newItem
        }).catchError{ (err) in
            throw self.handleError(err)
            }.do(onDispose: {
                self.loading.onNext(false)
            })
    }
    
    func delete(_ id: String) -> Observable<String> {
        loading.onNext(true)
        let url = URL(string: "\(baseUrl)/\(entityPath)/\(id)")!
        return client.request(url: url, method: .delete).mapTo(id).catchError{ (err) in
            throw self.handleError(err)
            }.do(onDispose: {
                self.loading.onNext(false)
            })
    }
    
    func handleError(_ err: Error) -> Error {
        switch err {
        case HttpClientError.clientSideError(let error):
            printError("Http Client Error \(error)")
            break
        case let HttpClientError.invalidResponse(response, data):
            printError("Server Error Response \(response), and returning data \(String(describing: data))")
            break
        case HttpClientError.invalidJsonObject:
            printError("Server returning an invalid json")
            break
        case HttpClientError.jsonDeserializationError(let err):
            printError("the json cannot be deserialized \(err)")
            break
        default:
            break
        }
        return err
    }
}
