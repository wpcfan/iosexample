//
//  HomeService.swift
//  Example
//
//  Created by 王芃 on 2019/1/28.
//  Copyright © 2019 twigcodes. All rights reserved.
//

class HomeService: ShouChuangService<HomeInfo> {
    var userId: String?
    var projectId: String?
    var houseId: String?
    override var smartApi: SmartApiType {
        get { return .home }
    }
    
    override func urlQueries() throws -> [URLQueryItem] {
        guard let userId = userId else { throw AppErr.requiredParamNull("Home Params Null") }
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "uid", value: userId)
            ]
        if (projectId != nil) {
            queryItems.append(URLQueryItem(name: "pid", value: projectId))
        }
        if (houseId != nil) {
            queryItems.append(URLQueryItem(name: "hid", value: houseId))
        }
        return queryItems
    }
}
