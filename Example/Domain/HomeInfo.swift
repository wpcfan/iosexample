//
//  Project.swift
//  Example
//
//  Created by 王芃 on 2018/10/12.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import ObjectMapper
import RxDataSources

struct HomeInfo: Mappable {
    var banners: [Banner]?
    var hasMessage: Bool?
    var devices: [Device]?
    var channels: [Channel]?
    var house: House?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        banners <- map["banners"]
        hasMessage <- map["hasmessage"]
        devices <- map["devices"]
        channels <- map["channels"]
        house <- map["houseinfo"]
    }
}
