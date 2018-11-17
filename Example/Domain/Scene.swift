//
//  Scene.swift
//  Example
//
//  Created by 王芃 on 2018/10/12.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import ObjectMapper
import RxDataSources

enum SceneIcon {
    case goHome
    case leaveHome
    case placeholder
}

struct Scene: Mappable {
    static func == (lhs: Scene, rhs: Scene) -> Bool {
        return lhs.identity == rhs.identity
    }
    
    var id: String?
    var name: String?
    var sceneIcon: SceneIcon?
    var builtIn: Bool?
    var order: Int?
    var countOfDevices: Int?
    var trigger: ScriptTrigger?
    var tasks: Array<ScriptTask>?
    init?(map: Map) {
        
    }
    
    init(id: String?, name: String, sceneIcon: SceneIcon, builtIn: Bool, order: Int, countOfDevices: Int, trigger: ScriptTrigger?, tasks: Array<ScriptTask>? = []) {
        self.id = id
        self.name = name
        self.sceneIcon = sceneIcon
        self.builtIn = builtIn
        self.order = order
        self.countOfDevices = countOfDevices
        self.trigger = trigger
        self.tasks = tasks
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        sceneIcon <- map["sceneIcon"]
        builtIn <- map["builtIn"]
        order <- map["order"]
        countOfDevices <- map["countOfDevices"]
        trigger <- map["trigger"]
        tasks <- map["tasks"]
    }
    
    var identity: String? {
        return id
    }
}
