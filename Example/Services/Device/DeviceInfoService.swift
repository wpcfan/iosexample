//
//  DeviceDetailService.swift
//  Example
//
//  Created by 王芃 on 2019/2/16.
//  Copyright © 2019 twigcodes. All rights reserved.
//

class DeviceInfoService: ShouChuangService<DeviceInfo> {
    override var smartApi: SmartApiType {
        get { return .deviceInfo }
    }
    
    override func urlQueries() throws -> [URLQueryItem] {
        
        guard let data = DiskUtil.getData() else { throw AppErr.requiredParamNull("Dis Data Is Null") }
        var queryItems: [URLQueryItem] = []
        if (data.houseId != nil) {
            queryItems.append(URLQueryItem(name: "hid", value: data.houseId))
        }
        return queryItems
    }
}
