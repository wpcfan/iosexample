//
//  Project.swift
//  Example
//
//  Created by 王芃 on 2018/10/12.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import ObjectMapper

struct HomeInfo: Mappable {
    var projectId: String?
    var banners: Array<Banner>?
    var channels: Array<Banner>?
    var scenes: Array<Scene>?
    
    
    init?(map: Map) {
        
    }
    
    init(projectId: String?, banners: Array<Banner>, channels: Array<Banner>, scenes: Array<Scene>) {
        self.projectId = projectId
        self.banners = banners
        self.channels = channels
        self.scenes = scenes
    }
    
    mutating func mapping(map: Map) {
        projectId <- map["projectId"]
        banners <- map["banners"]
        channels <- map["channels"]
        scenes <- map["scenes"]
    }
    
}
