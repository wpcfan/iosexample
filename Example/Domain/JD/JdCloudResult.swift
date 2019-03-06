//
//  SmartCloudResult.swift
//  Example
//
//  Created by 王芃 on 2019/2/13.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import ObjectMapper

class JdCloudResult: Mappable {
    var result: String?
    var status: Int?
    var cookie: String?
    var error: JdCloudError?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        result <- map["result"]
        status <- map["status"]
        cookie <- map["cookie"]
        error <- map["error"]
    }
}

class JdCloudStructureResult<T: Mappable>: Mappable {
    var result: T?
    var status: Int?
    var cookie: String?
    var error: JdCloudError?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        result <- map["result"]
        status <- map["status"]
        cookie <- map["cookie"]
        error <- map["error"]
    }
}

class JdNetConfigResult: Mappable {
    var result: JdNetConfigError?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        result <- map["result"]
    }
}
