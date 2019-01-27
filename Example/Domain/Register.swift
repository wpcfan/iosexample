//
//  Register.swift
//  Example
//
//  Created by 王芃 on 2019/1/21.
//  Copyright © 2019 twigcodes. All rights reserved.
//
import ObjectMapper

struct Version: Mappable {
    var version: String?
    var force: Bool?
    var needUpdate: Bool?
    var url: String?
    var desc: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        version <- map["version"]
        force <- map["force"]
        needUpdate <- map["needupdate"]
        url <- map["url"]
        desc <- map["describe"]
    }
}

struct SplashAd: Mappable {
    var imageUrl: String?
    var link: String?
    var id: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        imageUrl <- map["adurl"]
        link <- map["redirecturl"]
        id <- map["id"]
    }
}

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

struct Register: Mappable {
    
    var token: String?
    var version: Version?
    var splashAd: SplashAd?
    var user: SmartUser?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        token <- map["token"]
        version <- map["versioninfo"]
        splashAd <- map["adinfo"]
        user <- map["userinfo"]
    }
}
