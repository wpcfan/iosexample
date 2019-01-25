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
                throw handleError(err)
            }
            .do(onCompleted: {
                self.loading.onNext(false)
            })
    }
    
    func getAllResult() -> Observable<LeanCloudCollection<T>> {
        return page(skip: Constants.DEFAULT_PAGE_SKIP, limit: Constants.DEFAULT_PAGE_LIMIT, sort: nil, filter: nil)
    }
    
    func getAll() -> Observable<[T]> {
        return getAllResult().map { (collection) -> [T] in
            collection.results
        }
    }
    
    func count() -> Observable<Int> {
        return getAllResult().map { (collection) -> Int in
            collection.count
        }
    }
    /**
     Query the data and get paginated results
     
     - Parameter skip: the item position to start with
     - Parameter limit: the size of the data returned
     - Parameter sort: the order to sort the data
     - Parameter filter: the condition to filter the data
     
     - Returns: A stream encapsulated in LeanCloudCollection
     */
    func page(skip: Int, limit: Int, sort: String? = nil, filter: String? = nil) -> Observable<LeanCloudCollection<T>> {
        loading.onNext(true)
        var urlComponents = URLComponents(string: "\(baseUrl)/\(entityPath)")!
        var queries = [
            URLQueryItem(name: "count", value: String(Constants.DEFAULT_COUNT)),
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "skip", value: String(skip))
        ]
        if let sort = sort {
            queries.append(URLQueryItem(name: "order", value: sort))
        }
        if let filter = filter {
            queries.append(URLQueryItem(name: "where", value: filter))
        }
        urlComponents.queryItems = queries
        let req = URLRequest(url: urlComponents.url!, headers: self.reqHeaders)
        return client.requestJson(req).map{ (json) in
            let res = json as! [String: Any]
            let collection = Mapper<LeanCloudCollection<T>>().map(JSON: res)!
            return collection
            }.retry(3)
            .catchError{ (err) in
                throw handleError(err)
            }.do(onCompleted: {
                self.loading.onNext(false)
            })
            .share()
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
            throw handleError(err)
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
            throw handleError(err)
            }.do(onDispose: {
                self.loading.onNext(false)
            })
    }
    
    func delete(_ id: String) -> Observable<String> {
        loading.onNext(true)
        let url = URL(string: "\(baseUrl)/\(entityPath)/\(id)")!
        return client.request(url: url, method: .delete).mapTo(id).catchError{ (err) in
            throw handleError(err)
            }.do(onDispose: {
                self.loading.onNext(false)
            })
    }
    
    
}
