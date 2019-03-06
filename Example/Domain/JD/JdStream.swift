//
//  SCStream.swift
//  Example
//
//  Created by 王芃 on 2019/2/14.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import ObjectMapper

class JdStream: Mappable {
    var id: String?
    var value: String?
    var type: String?
    var name: String?
    var at: String?
    var units: String?
    var paramType: String?
    var tagId: Int?
    var valueDesc: String?
    var valueDict: Dictionary<String, String>?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["stream_id"]
        value <- map["current_value"]
        type <- map["stream_type"]
        name <- map["stream_name"]
        at <- map["at"]
        units <- map["units"]
        paramType <- map["ptype"]
        tagId <- map["tag_id"]
        valueDesc <- map["value_des"]
    }
}
