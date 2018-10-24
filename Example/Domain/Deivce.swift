//
//  Deivce.swift
//  Example
//
//  Created by 王芃 on 2018/10/12.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import ObjectMapper
import RxDataSources

struct Device: Mappable, ModelType, IdentifiableType, Equatable {
    var id: String?
    var deviceId: String?
    var gatewayId: String?
    var product: Product?
    
    init?(map: Map) {
        
    }
    
    init(id: String?, deviceId: String, gatewayId: String, product: Product) {
        self.id = id
        self.deviceId = deviceId
        self.gatewayId = gatewayId
        self.product = product
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        deviceId <- map["deviceId"]
        gatewayId <- map["gatewayId"]
        product <- map["product"]
    }
    
    var identity: String? {
        return id
    }
}
