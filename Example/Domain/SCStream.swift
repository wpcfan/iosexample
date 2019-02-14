//
//  SCStream.swift
//  Example
//
//  Created by 王芃 on 2019/2/14.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import ObjectMapper

struct SCStream: Mappable {
    var id: String?
    var value: String?
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["stream_id"]
        value <- map["current_value"]
    }
}
