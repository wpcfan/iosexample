//
//  SciptTrigger.swift
//  Example
//
//  Created by 王芃 on 2018/10/12.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import ObjectMapper
import RxDataSources

enum TriggerType {
    case manual
    case anyOf
    case allOf
}

struct ScriptTrigger: Mappable {
    var id: String?
    var type: TriggerType?
    var cronExpr: String?
    var deviceAttributes: Dictionary<String, String>?
    
    init?(map: Map) {
        
    }
    
    init(id: String?, type: TriggerType, cronExpr: String, deviceAttributes: Dictionary<String, String>) {
        self.id = id
        self.type = type
        self.cronExpr = cronExpr
        self.deviceAttributes = deviceAttributes
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        type <- map["type"]
        cronExpr <- map["cronExpr"]
        deviceAttributes <- map["deviceAttributes"]
    }
}
