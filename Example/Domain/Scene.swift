//
//  Scene.swift
//  Example
//
//  Created by 王芃 on 2018/10/12.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import ObjectMapper

struct Scene: Mappable {
    var id: String?
    var name: String?
    var imageUrl: String?
    var countOfDevices: Int?
    var trigger: ScriptTrigger?
    var tasks: Array<ScriptTask>?
    init?(map: Map) {
        
    }
    
    init(id: String?, name: String, imageUrl: String, countOfDevices: Int, trigger: ScriptTrigger?, tasks: Array<ScriptTask>? = []) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.countOfDevices = countOfDevices
        self.trigger = trigger
        self.tasks = tasks
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        imageUrl <- map["imageUrl"]
        countOfDevices <- map["countOfDevices"]
        trigger <- map["trigger"]
        tasks <- map["tasks"]
    }
    
}
