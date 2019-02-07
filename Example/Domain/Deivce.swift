//
//  Deivce.swift
//  Example
//
//  Created by 王芃 on 2018/10/12.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import ObjectMapper
import RxDataSources

struct ServiceInfo: Mappable, Codable {
    var port: Int?
    var isMultipoint: Bool?
    var version: String?
    var type: Int?
    var transType: Int?
    var ip: String?
    var name: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        port <- map["port"]
        isMultipoint <- map["isMultipoint"]
        version <- map["version"]
        type <- map["type"]
        transType <- map["transType"]
        ip <- map["ip"]
        name <- map["name"]
    }
}

struct Device: Mappable, Codable {
    var id: String?
    var feedId: String?
    var guid: String?
    var deviceName: String?
    var productId: String?
    var sort: Int?
    var from: String?
    var isSubdevice: Bool?
    var productImageUrl: String?
    var version: String?
    var status: Int?
    var infoStatus: Int?
    var serviceInfos: [ServiceInfo]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        feedId <- map["feedid"]
        guid <- map["guid"]
        deviceName <- map["devicename"]
        productId <- map["puid"]
        sort <- map["sort"]
        from <- map["from"]
        isSubdevice <- map["issubdevice"]
        productImageUrl <- map["image"]
        version <- map["version"]
        status <- map["status"]
        infoStatus <- map["infostatus"]
        serviceInfos <- map["service_infos"]
    }
}
