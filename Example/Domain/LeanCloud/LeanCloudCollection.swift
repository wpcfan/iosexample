//
//  LeanCloudResult.swift
//  Example
//
//  Created by 王芃 on 2019/1/19.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import ObjectMapper

class LeanCloudCollection<T>: Mappable where T: Mappable {
    var results: [T] = []
    var count = 0
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        results <- map["results"]
        count <- map["count"]
    }
}
