//
//  Project.swift
//  Example
//
//  Created by 王芃 on 2018/10/12.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import ObjectMapper
import RxDataSources

struct HomeInfo: Mappable, Codable {
    var banners: [Banner]?
    var hasMessage: Bool?
    var devices: [Device]?
    var channels: [Channel]?
    var house: House?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        banners <- map["banner"]
        hasMessage <- map["hasmessage"]
        devices <- map["devices"]
        channels <- map["thirdlink"]
        house <- map["houseinfo"]
    }
}
