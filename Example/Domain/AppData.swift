//
//  AppData.swift
//  Example
//
//  Created by 王芃 on 2018/10/7.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import ObjectMapper

struct AppData: Codable, Mappable {
    var tourGuidePresented: Bool?
    var user: SmartUser?
    var houseId: String?
    var projectId: String?
    var token: String?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        tourGuidePresented <- map["tourGuidePresented"]
        user <- map["user"]
        houseId <- map["houseId"]
        projectId <- map["projectId"]
        token <- map["token"]
    }
}
