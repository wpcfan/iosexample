//
//  User.swift
//  Example
//
//  Created by 王芃 on 2018/9/28.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import ObjectMapper

struct User: Mappable {
    var id: String?
    var login: String?
    var password: String?
    var mobile: String?
    var email: String?
    var name: String?
    var avatar: String?
    var authorities: [String]?
    
    init?(map: Map) {
        
    }
    
    init(id: String?, login: String, mobile: String, email: String, name: String, avatar: String) {
        self.id = id
        self.login = login
        self.mobile = mobile
        self.email = email
        self.name = name
        self.avatar = avatar
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        login <- map["login"]
        password <- map["password"]
        mobile <- map["mobile"]
        email <- map["email"]
        name <- map["name"]
        avatar <- map["avatar"]
        authorities <- map["authorities"]
    }
}
