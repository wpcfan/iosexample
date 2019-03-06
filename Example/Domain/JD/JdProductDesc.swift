//
//  JdProductDesc.swift
//  Example
//
//  Created by 王芃 on 2019/3/6.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import ObjectMapper

class OneKeyConfigDesc: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        detail <- map["detail"]
        seq <- map["seq"]
        h5Url <- map["h5_url"]
        imageUrl <- map["url"]
    }
    
    var detail: String?
    var seq: String?
    var h5Url: String?
    var imageUrl: String?
}

class JdProductDesc: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        content <- map["content"]
        version <- map["desc_version"]
        oneKeyConfigDescArr <- map["onkeyconfig"]
    }
    
    var content: String?
    var version: String?
    var oneKeyConfigDescArr: [OneKeyConfigDesc]?
}
