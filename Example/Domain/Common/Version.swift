//
//  Version.swift
//  Example
//
//  Created by 王芃 on 2019/2/14.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import ObjectMapper

class Version: Mappable {
    var version: String?
    var force: Bool?
    var needUpdate: Bool?
    var url: String?
    var desc: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        version <- map["version"]
        force <- map["force"]
        needUpdate <- map["needupdate"]
        url <- map["url"]
        desc <- map["describe"]
    }
}
