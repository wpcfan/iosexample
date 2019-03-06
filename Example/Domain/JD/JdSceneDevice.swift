//
//  JdSceneDevice.swift
//  Example
//
//  Created by 王芃 on 2019/3/4.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import ObjectMapper

class JdSceneDevice: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
    }
    
    var version: String?
    var type: Int?
    var feedId: Int64?
    var productId: String?
}
