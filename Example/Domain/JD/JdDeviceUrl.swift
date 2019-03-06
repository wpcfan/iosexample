//
//  SCDeviceUrl.swift
//  Example
//
//  Created by 王芃 on 2019/2/16.
//  Copyright © 2019 twigcodes. All rights reserved.
//
import ObjectMapper

class SCProduct: Mappable {
    var id: Int?
    var desc: String?
    var name: String?
    var configType: Int?
    var lancon: String?
    var isShowResetJoinnet: Bool?
    var type: Int?
    var shareFlag: Int?
    var supportAFS: Int?
    var templateType: String?
    var categoryId: Int?
    var protocolVersion: String?
    var productUUID: String?
    var typeDesc: String?
    var imageUrl: String?
    var typeName: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        isShowResetJoinnet <- map["is_show_resetjoinnet"]
        desc <- map["p_description"]
        lancon <- map["lancon"]
        id <- map["product_id"]
        configType <- map["config_type"]
        name <- map["product_name"]
        type <- map["pro_type"]
        shareFlag <- map["share_flag"]
        supportAFS <- map["supportAFS"]
        templateType <- map["template_type"]
        categoryId <- map["cid"]
        protocolVersion <- map["protocol_version"]
        productUUID <- map["product_uuid"]
        typeDesc <- map["type_desc"]
        imageUrl <- map["p_img_url"]
        typeName <- map["type_name"]
    }
}

class SharedInfo: Mappable {
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        sharedCount <- map["shared_count"]
        isShared <- map["isShared"]
    }
    
    var sharedCount: Int?
    var isShared: Bool?
}

class H5: Mappable {
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        version <- map["version"]
        url <- map["url"]
    }
    
    var version: Int?
    var url: String?
}

class SCDevice: Mappable {
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
    var product: SCProduct?
    var sharedInfo: SharedInfo?
    var h5: H5?
    var device: SCDevice?
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
