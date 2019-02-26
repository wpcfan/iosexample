//
//  SmartCloudResult.swift
//  Example
//
//  Created by 王芃 on 2019/2/13.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import ObjectMapper

struct SmartCloudResult: Mappable {
    var result: String?
    var status: Int?
    var cookie: String?
    var error: SmartCloudError?
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        result <- map["result"]
        status <- map["status"]
        cookie <- map["cookie"]
        error <- map["error"]
    }
}

struct SmartCloudStructureResult<T: Mappable>: Mappable {
    var result: T?
    var status: Int?
    var cookie: String?
    var error: SmartCloudError?
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        result <- map["result"]
        status <- map["status"]
        cookie <- map["cookie"]
        error <- map["error"]
    }
}
