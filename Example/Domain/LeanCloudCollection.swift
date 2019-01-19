//
//  LeanCloudResult.swift
//  Example
//
//  Created by 王芃 on 2019/1/19.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import ObjectMapper

struct LeanCloudResult<T>: Mappable where T: Mappable {
    var results: [T] = []
    var count = 0
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        results <- map["results"]
        count <- map["count"]
    }
}
