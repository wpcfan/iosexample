//
//  Banner.swift
//  Example
//
//  Created by 王芃 on 2018/10/11.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import ObjectMapper

struct Banner: Mappable, Codable {
    
    var id: String?
    var imageUrl: String?
    var title: String?
    var link: String?
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        imageUrl <- map["adurl"]
        title <- map["title"]
        link <- map["redirecturl"]
    }
}
