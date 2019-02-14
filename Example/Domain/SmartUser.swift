//
//  SmartUser.swift
//  Example
//
//  Created by 王芃 on 2019/2/14.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import ObjectMapper

struct SmartUser: Codable, Mappable {
    var id: String?
    var allInfo: Bool?
    var marital: Bool?
    var gender: Bool?
    var jdAccountBinded: Bool?
    var jdAccessToken: String?
    var loggedIn: Bool?
    var name: String?
    var mobile: String?
    var type: Int?
    var idCard: String?
    var avatar: String?
    var houseCount: Int?
    var birthDay: TimeInterval?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["uid"]
        allInfo <- map["isallinfo"]
        jdAccessToken <- map["accessToken"]
        marital <- map["marital"]
        jdAccountBinded <- map["isbind"]
        loggedIn <- map["login"]
        name <- map["realname"]
        mobile <- map["phone"]
        type <- map["type"]
        idCard <- map["idcard"]
        avatar <- map["avatar"]
        houseCount <- map["housecount"]
        birthDay <- map["birthday"]
        gender <- map["gender"]
    }
}

