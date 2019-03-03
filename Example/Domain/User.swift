//
//  User.swift
//  Example
//
//  Created by 王芃 on 2018/9/28.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import ObjectMapper

class User: Mappable {
    var id: String?
    var login: String?
    var password: String?
    var mobile: String?
    var email: String?
    var name: String?
    var avatar: String?
    var authorities: [String]?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
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
