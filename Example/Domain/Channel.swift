//
//  Channle.swift
//  Example
//
//  Created by 王芃 on 2019/2/14.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import ObjectMapper

struct Channel: Mappable, Codable {
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
