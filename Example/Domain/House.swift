//
//  House.swift
//  Example
//
//  Created by 王芃 on 2018/10/12.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import ObjectMapper
import RxDataSources

struct House: Mappable, Codable {
    var id: String?
    var projectId: String?
    var projectName: String?
    var stage: String?
    var houseNo: String?
    var unitNo: String?
    var roomNo: String?
    var familyMemberCount: Int?
    var sceneCount: Int?
    var deviceCount: Int?
    var groupCount: Int?
    var isOwner: Bool?
    var jdAccessToken: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["hid"]
        projectId <- map["pid"]
        projectName <- map["pname"]
        stage <- map["stage"]
        houseNo <- map["num"]
        unitNo <- map["unitno"]
        roomNo <- map["roomnum"]
        familyMemberCount <- map["familynum"]
        sceneCount <- map["scenenum"]
        deviceCount <- map["devicenum"]
        groupCount <- map["groupnum"]
        isOwner <- map["isOwner"]
        jdAccessToken <- map["accessToken"]
    }
    
    func displayName() -> String {
        return "\(houseNo ?? "")-\(unitNo ?? "")-\(roomNo ?? "")-\(projectName ?? "")"
    }
}
