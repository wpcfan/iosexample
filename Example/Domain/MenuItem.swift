//
//  MenuItem.swift
//  Example
//
//  Created by 王芃 on 2018/11/14.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import ObjectMapper

struct MenuItem: Mappable {
    var title: String?
    var desc: String?
    
    init?(map: Map) {
        
    }
    
    init(title: String?, desc: String) {
        self.title = title
        self.desc = desc
    }
    
    mutating func mapping(map: Map) {
        title <- map["title"]
        desc <- map["desc"]
    }
}
