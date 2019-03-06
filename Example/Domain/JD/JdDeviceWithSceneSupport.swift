//
//  JdDeviceWIthSceneSupport.swift
//  Example
//
//  Created by 王芃 on 2019/3/5.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import ObjectMapper

class JdDeviceWithSceneSupport: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        appImageUrl <- map["app_pic"]
        createdAt <- map["create_time"]
        deviceName <- map["device_name"]
        feedId <- map["feed_id"]
        productDesc <- map["p_description"]
        productImageUrl <- map["p_img_url"]
        productType <- map["pro_type"]
        productId <- map["product_id"]
        productUUID <- map["productUUID"]
        type <- map["type"]
        version <- map["version"]
        streams <- map["stream"]
    }
    
    var appImageUrl: String?
    var createdAt: Date?
    var deviceName: String?
    var feedId: String?
    var productDesc: String?
    var productImageUrl: String?
    var productType: String?
    var productId: String?
    var productUUID: String?
    var type: Int?
    var version: String?
    var streams: [JdStream]?
}
