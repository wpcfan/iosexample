//
//  HouseScene.swift
//  Example
//
//  Created by 王芃 on 2019/2/25.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import ObjectMapper

struct HouseScene: Mappable, Codable, Equatable {
    static func == (lhs: HouseScene, rhs: HouseScene) -> Bool {
        return lhs.id == rhs.id
    }
    var id: String?
    var scriptId: String?
    var innerCode: Int?
    var houseId: String?
    var scene: Scene?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        scriptId <- map["script_id"]
        innerCode <- map["innercode"]
        houseId <- map["hid"]
    }
}
