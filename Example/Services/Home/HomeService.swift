//
//  HomeService.swift
//  Example
//
//  Created by 王芃 on 2019/1/28.
//  Copyright © 2019 twigcodes. All rights reserved.
//
import RxSwift
import Disk

class HomeService: ShouChuangService<HomeInfo> {
    override var smartApi: SmartApiType {
        get { return .home }
    }
    
    override func urlQueries() throws -> [URLQueryItem] {
        let data = try? Disk.retrieve(Constants.APP_DATA_PATH, from: .documents, as: AppData.self)
        
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
    
    func handleHomeInfo() -> Observable<HomeInfo> {
        return request()
            .do(onNext: { (home: HomeInfo) in
                CURRENT_HOUSE.onNext(home.house)
                var appData = try Disk.retrieve(Constants.APP_DATA_PATH, from: .documents, as: AppData.self)
                appData.houseId = home.house?.id
                appData.projectId = home.house?.projectId
                try Disk.save(appData, to: .documents, as: Constants.APP_DATA_PATH)
            })
    }
}
