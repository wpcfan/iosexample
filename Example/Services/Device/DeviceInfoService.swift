//
//  DeviceDetailService.swift
//  Example
//
//  Created by 王芃 on 2019/2/16.
//  Copyright © 2019 twigcodes. All rights reserved.
//

class DeviceInfoService: ShouChuangService<DeviceInfo> {
    var deviceId: String?
    override var smartApi: SmartApiType {
        get { return .deviceInfo }
    }
    
    override func urlQueries() throws -> [URLQueryItem] {
        
        guard let data = DiskUtil.getData(), let deviceId = deviceId else { throw AppErr.requiredParamNull("DeviceInfoService Param Is Null") }
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "did", value: deviceId)
        ]
        if (data.user?.id != nil) {
            queryItems.append(URLQueryItem(name: "p2", value: data.user!.id))
        }
        if (data.houseId != nil) {
            queryItems.append(URLQueryItem(name: "p3", value: data.houseId))
        }
        return queryItems
    }
}
