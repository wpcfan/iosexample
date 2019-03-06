//
//  SCDeviceUrl.swift
//  Example
//
//  Created by 王芃 on 2019/2/16.
//  Copyright © 2019 twigcodes. All rights reserved.
//
import ObjectMapper

class JdSharedInfo: Mappable {
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        sharedCount <- map["shared_count"]
        isShared <- map["isShared"]
    }
    
    var sharedCount: Int?
    var isShared: Bool?
}

class JdH5: Mappable {
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        version <- map["version"]
        url <- map["url"]
    }
    
    var version: Int?
    var url: String?
}

class JdDeviceStatus: Mappable {
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        name <- map["device_name"]
        status <- map["status"]
        active_time <- map["active_time"]
        id <- map["device_id"]
        accessKey <- map["access_key"]
        feedId <- map["feed_id"]
        mainSubType <- map["main_sub_type"]
    }
    
    var name: String?
    var status: Int?
    var active_time: Date?
    var id: String?
    var accessKey: String?
    var feedId: Int64?
    var mainSubType: Int?
}

class JdDeviceUrl: Mappable {
    var product: JdProduct?
    var sharedInfo: JdSharedInfo?
    var h5: JdH5?
    var device: JdDeviceStatus?
    var streams: [Stream]?
    var newDesc: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        product <- map["product"]
        sharedInfo <- map["shared_info"]
        h5 <- map["h5"]
        device <- map["device"]
        streams <- map["streams"]
        newDesc <- map["newdesc"]
    }
}
