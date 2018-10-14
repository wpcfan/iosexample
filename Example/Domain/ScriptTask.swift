//
//  ScriptCondition.swift
//  Example
//
//  Created by 王芃 on 2018/10/12.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import ObjectMapper

struct ScriptTask: Mappable {
    var id: String?
    var deviceAttributes: Dictionary<String, String>?
    var nextId: String?
    var delay: Int?
    
    init?(map: Map) {
        
    }
    
    init(id: String?, deviceAttributes: Dictionary<String, String>, nextId: String, delay: Int) {
        self.id = id
        self.deviceAttributes = deviceAttributes
        self.nextId = nextId
        self.delay = delay
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        deviceAttributes <- map["deviceAttributes"]
        nextId <- map["nextId"]
        delay <- map["delay"]
    }
    
}
