//
//  SmartCloudResult.swift
//  Example
//
//  Created by 王芃 on 2019/2/13.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import ObjectMapper
import Dollar

struct SCStream: Mappable {
    var id: String?
    var value: String?
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["stream_id"]
        value <- map["current_value"]
    }
}

struct SCV2Snapshot: Mappable {
    var status: String?
    var digest: String?
    var streams: [SCStream]?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        status <- map["status"]
        digest <- map["digest"]
        streams <- map["streams"]
    }
    
    func toDictionary() -> Dictionary<String, SCStream> {
        return (streams ?? []).keyBy({ (stream) -> String in
            stream.id!
        })
    }
}

struct SmartCloudError: Mappable {
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
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
