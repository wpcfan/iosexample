//
//  SmartCloudError.swift
//  Example
//
//  Created by 王芃 on 2019/2/14.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import ObjectMapper

class JdCloudError: Mappable {
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        errorInfo <- map["errorInfo"]
        errorCode <- map["errorCode"]
        debugInfo <- map["debugInfo"]
        debugMe <- map["debugMe"]
    }
    
    var errorInfo: String?
    var errorCode: Int?
    var debugInfo: String?
    var debugMe: String?
}

class JdNetConfigError: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["statusMsg"]
    }
    
    var status: Int?
    var message: String?
}

enum SCError: Error {
    case JdSmartError(_ code: Int?, _ message: String?, _ debug: String?)
    case NetConfigError(_ status: Int?, _ message: String?)
}
