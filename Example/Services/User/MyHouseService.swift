//
//  MyHouseService.swift
//  Example
//
//  Created by 王芃 on 2019/2/1.
//  Copyright © 2019 twigcodes. All rights reserved.
//

class MyHouseService: ShouChuangCollectionService<House> {
    var userId: String?
    override var smartApi: SmartApiType {
        get { return .myHouses }
    }
    
    override func urlQueries() throws -> [URLQueryItem] {
        guard let userId = userId else { throw AppErr.requiredParamNull("MyHouses Params Null") }
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "uid", value: userId)
            ]
        return queryItems
    }
}
