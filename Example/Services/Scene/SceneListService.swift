//
//  SceneListService.swift
//  Example
//
//  Created by 王芃 on 2019/2/25.
//  Copyright © 2019 twigcodes. All rights reserved.
//

class SceneListService: ShouChuangCollectionService<HouseScene> {
    
    override var smartApi: SmartApiType {
        get { return .scenes }
    }
    
    override func urlQueries() throws -> [URLQueryItem] {
        let data = DiskUtil.getData()
        guard let userId = data?.user?.id, let houseId = data?.houseId else { throw AppErr.requiredParamNull("SceneListService Params Null") }
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "uid", value: userId),
            URLQueryItem(name: "hid", value: houseId)
        ]
        return queryItems
    }
}
