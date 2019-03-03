//
//  MenuItem.swift
//  Example
//
//  Created by 王芃 on 2018/11/14.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import ObjectMapper

class MenuItem: Mappable {
    var title: String?
    var desc: String?
    
    required init?(map: Map) { }
    
    init(title: String?, desc: String) {
        self.title = title
        self.desc = desc
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        desc <- map["desc"]
    }
}
