//
//  JdServiceInfo.swift
//  Example
//
//  Created by 王芃 on 2019/3/4.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import ObjectMapper

class JdServiceInfo: Mappable, Codable {
    var port: Int?
    var isMultipoint: Bool?
    var version: String?
    var type: Int?
    var transType: Int?
    var ip: String?
    var name: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        port <- map["port"]
        isMultipoint <- map["isMultipoint"]
        version <- map["version"]
        type <- map["type"]
        transType <- map["transType"]
        ip <- map["ip"]
        name <- map["name"]
    }
}
