//
//  DeviceInfo.swift
//  Example
//
//  Created by 王芃 on 2019/2/15.
//  Copyright © 2019 twigcodes. All rights reserved.
//
import ObjectMapper

class DeviceInfo: Mappable {
    var id: String?
    var projectId: String?
    var houseId: String?
    var feedId: String?
    var guid: String?
    var gatewayGUID: String?
    var pin: Int64?
    var status: Int?
    var createdAt: Date?
    var categoryId: Int?
    var categoryImageUrl: String?
    var productV2Id: String?
    var productV3Id: String?
    var productImageUrl: String?
    var productVersion: String?
    var userId: String?
    var deviceId: String?
    var deviceName: String?
    var deviceBle: String?
    var deviceType: Int?
    var infoStatus: Int?
    var bindedAt: Date?
    var mainSubType: Int?
    var ownedFlag: Bool?
    var from: Int?
    var serviceInfos: [ServiceInfo]?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["id"]
        projectId <- map["pid"]
        houseId <- map["hid"]
        feedId <- map["feed_id"]
        guid <- map["guid"]
        gatewayGUID <- map["gw_guid"]
        pin <- map["pin"]
        status <- map["status"]
        createdAt <- map["create_time"]
        categoryId <- map["cid"]
        categoryImageUrl <- map["c_img_url"]
        productV2Id <- map["product_uuid"]
        productV3Id <- map["puid"]
        productImageUrl <- map["p_img_url"]
        productVersion <- map["version"]
        userId <- map["uid"]
        deviceName <- map["device_name"]
        deviceId <- map["device_id"]
        deviceBle <- map["device_ble"]
        deviceType <- map["device_type"]
        infoStatus <- map["infostatus"]
        bindedAt <- map["bindtime"]
        mainSubType <- map["main_sub_type"]
        ownedFlag <- map["own_flag"]
        from <- map["from"]
        serviceInfos <- map["service_infos"]
    }
}
