//
//  SmartHomeResult.swift
//  Example
//
//  Created by 王芃 on 2019/1/21.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import ObjectMapper

protocol SmartHomeEntity {
    var entityPath: String { get }
}

class SmartHomeResult<T: Mappable>: Mappable {
    var result: Bool?
    var data: T?
    var errorCode: Int?
    var message: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        result <- map["result"]
        data <- map["data"]
        errorCode <- map["error_code"]
        message <- map["message"]
    }
}

class SmartHomeCollectionResult<T: Mappable>: Mappable {
    var result: Bool?
    var data: [T]?
    var errorCode: Int?
    var message: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        result <- map["result"]
        data <- map["data"]
        errorCode <- map["error_code"]
        message <- map["message"]
    }
}
