//
//  Scene.swift
//  Example
//
//  Created by 王芃 on 2018/10/12.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import ObjectMapper

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
    init?(map: Map) {
        
    }
    
    init(id: String?, name: String, sceneIcon: SceneIcon, builtIn: Bool, order: Int, countOfDevices: Int) {
        self.id = id
        self.name = name
        self.sceneIcon = sceneIcon
        self.builtIn = builtIn
        self.order = order
        self.countOfDevices = countOfDevices
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        sceneIcon <- map["sceneIcon"]
        builtIn <- map["builtIn"]
        order <- map["order"]
        countOfDevices <- map["countOfDevices"]
    }
    
    var identity: String? {
        return id
    }
}
