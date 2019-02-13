//
//  HomeService.swift
//  Example
//
//  Created by 王芃 on 2019/1/28.
//  Copyright © 2019 twigcodes. All rights reserved.
//
import RxSwift

class HomeService: ShouChuangService<HomeInfo> {
    override var smartApi: SmartApiType {
        get { return .home }
    }
    
    override func urlQueries() throws -> [URLQueryItem] {
        let data = DiskUtil.getData()
        
        guard let cache = data else { throw AppErr.requiredParamNull("Dis Data Is Null") }
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "uid", value: cache.user?.id)
            ]
        
        if (cache.projectId != nil) {
            queryItems.append(URLQueryItem(name: "pid", value: cache.projectId))
        }
        if (cache.houseId != nil) {
            queryItems.append(URLQueryItem(name: "hid", value: cache.houseId))
        }
        return queryItems
    }
    
    func handleHomeInfo(cached: Bool = false) -> Observable<HomeInfo> {
        return request(cached: cached)
            .do(onNext: { (home: HomeInfo) in
                DiskUtil.saveHouseInfo(house: home.house!)
            })
    }
}
