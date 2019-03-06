//
//  JdProductInfo.swift
//  Example
//
//  Created by 王芃 on 2019/3/6.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import ObjectMapper

class JdProductInfo: Mappable {
    var id: Int?
    var uuid: String?
    var bleProtocol: String?
    var categoryId: Int?
    var configType: Int?
    var desc: String?
    var deviceType: String?
    var imageUrl: String?
    var isSupport: Bool?
    var lancon: Int?
    var mainSubType: Int?
    var name: String?
    var newDesc: Bool?
    var protocolVersion: String?
    var publicFlag: Bool?
    var version: String?
    var qrCode: String?
    var deviceMac: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["product_id"]
        bleProtocol <- map["ble_protocol"]
        categoryId <- map["cid"]
        configType <- map["config_type"]
        desc <- map["description"]
        deviceType <- map["device_type"]
        imageUrl <- map["img_url"]
        isSupport <- map["is_support"]
        lancon <- map["lancon"]
        mainSubType <- map["main_sub_type"]
        name <- map["name"]
        newDesc <- map["newdesc"]
        protocolVersion <- map["protocol_version"]
        publicFlag <- map["public_flag"]
        version <- map["version"]
    }
}
