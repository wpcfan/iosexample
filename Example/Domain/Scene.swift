//
//  Scene.swift
//  Example
//
//  Created by 王芃 on 2018/10/12.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import ObjectMapper

struct ScriptLogic: Mappable, Codable, Equatable {
    static func == (lhs: ScriptLogic, rhs: ScriptLogic) -> Bool {
        return lhs.id == rhs.id
    }
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        base <- map["base"]
        delay <- map["delay"]
        en <- map["en"]
        eventId <- map["events"]
        index <- map["index"]
        next <- map["next"]
        notation <- map["notation"]
    }
    
    var id: String?
    var base: Int?
    var delay: Int?
    var drift: Int?
    var en: Int?
    var eventId: String?
    var index: Int?
    var next: Int?
    var notation: String?
}

struct EventObjectInput: Mappable, Codable {
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        type <- map["type"]
    }
    
    var name: String?
    var type: String?
}

struct EventCondition: Mappable, Codable {
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        op <- map["operator"]
        type <- map["type"]
        value <- map["value"]
    }
    
    var name: String?
    var op: String?
    var type: String?
    var value: String?
}

struct EventObject: Mappable, Codable {
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        input <- map["in"]
        name <- map["name"]
    }
    
    var input: [EventObjectInput]?
    var name: String?
}

struct ScriptEvent: Mappable, Codable, Equatable {
    static func == (lhs: ScriptEvent, rhs: ScriptEvent) -> Bool {
        return lhs.id == rhs.id
    }
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        guid <- map["GUID"]
        interval <- map["interval"]
        member <- map["member"]
        eventObject <- map["obj"]
        service <- map["service"]
        type <- map["type"]
        condition <- map["condition"]
    }
    
    var id: String?
    var guid: String?
    var interval: Int?
    var member: String?
    var service: String?
    var type: String?
    var condition: [EventCondition]?
    var eventObject: EventObject?
}

struct ActionParam: Mappable, Codable {
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        multiValues <- map["value"]
        singleValue <- map["value"]
        type <- map["type"]
    }
    
    var values: [String]? {
        get {
            return singleValue == nil ?
                multiValues :
                singleValue != nil ?
                    [self.singleValue!] : nil
        }
    }
    var name: String?
    var multiValues: [String]?
    var singleValue: String?
    var type: String?
}

struct ActionObject: Mappable, Codable {
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        access <- map["access"]
        name <- map["name"]
        range <- map["range"]
        type <- map["type"]
    }
    
    var access: String?
    var name: String?
    var range: [String]?
    var type: String?
}

struct ScriptAction: Mappable, Codable, Equatable {
    static func == (lhs: ScriptAction, rhs: ScriptAction) -> Bool {
        return lhs.id == rhs.id
    }
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        guid <- map["GUID"]
        member <- map["member"]
        actionObject <- map["obj"]
        actionParam <- map["param"]
        service <- map["service"]
        type <- map["type"]
    }
    
    var id: String?
    var guid: String?
    var member: String?
    var service: String?
    var type: String?
    var actionObject: ActionObject?
    var actionParam: [ActionParam]?
}

struct Script: Mappable, Codable, Equatable {
    static func == (lhs: Script, rhs: Script) -> Bool {
        return lhs.id == rhs.id
    }
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        version <- map["version"]
        shareUserCnt <- map["share_user_cnt"]
        isOwner <- map["is_owner"]
        isShareable <- map["is_shareable"]
        shareUsers <- map["share_users"]
        actions <- map["actions"]
        events <- map["events"]
        logic <- map["logic"]
    }
    
    var id: String?
    var version: String?
    var shareUserCnt: Int?
    var isOwner: Bool?
    var isShareable: Bool?
    var shareUsers: [String]?
    var actions: [ScriptAction]?
    var events: [ScriptEvent]?
    var logic: [ScriptLogic]?
}


struct Scene: Mappable, Codable {
    var name: String?
    var deviceCount: Int?
    var script: Script?
    var scriptStatus: Bool?
    var displayName: String? {
        get {
            guard let name = name else { return nil }
            let subStrArr = name.split(separator: "#", maxSplits: 1)
            return subStrArr.count == 0 ? name : String(subStrArr[0])
        }
    }
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        deviceCount <- map["device_count"]
        script <- map["script"]
        scriptStatus <- map["script_status"]
        name <- (map["name"].isKeyPresent ? map["name"] : map["script.logic.0.notation"])
    }
}

struct SceneCollection: Mappable, Codable {
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        count <- map["count"]
        scripts <- map["scripts"]
    }
    
    var count: Int?
    var scripts: [Scene]?
}
