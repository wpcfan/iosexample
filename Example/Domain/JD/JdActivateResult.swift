//
//  JdActivateResult.swift
//  Example
//
//  Created by 王芃 on 2019/3/7.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import ObjectMapper

class JdActivateResult: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        feedId <- map["feed_id"]
        deviceName <- map["name"]
        productUUID <- map["puid"]
    }
    
    var feedId: String?
    var deviceName: String?
    var productUUID: String?
}
