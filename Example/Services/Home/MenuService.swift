//
//  MenuService.swift
//  Example
//
//  Created by 王芃 on 2019/1/28.
//  Copyright © 2019 twigcodes. All rights reserved.
//
import RxSwift
import Disk
import ObjectMapper

struct SideBarMenuCount: Mappable {
    var familyCount: Int?
    var groupCount: Int?
    var deviceCount: Int?
    var sceneCount: Int?
    var houseCount: Int?
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        familyCount <- map["familynum"]
        groupCount <- map["groupnum"]
        deviceCount <- map["devicenum"]
        sceneCount <- map["scenenum"]
        houseCount <- map["housenum"]
    }
}

class MenuService: ShouChuangService<SideBarMenuCount> {
    override var smartApi: SmartApiType {
        get { return .sideMenuItems }
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
}
