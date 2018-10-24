//
//  APIError.swift
//  Example
//
//  Created by 王芃 on 2018/10/16.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import ObjectMapper

struct APIError: Mappable {
    var title: String?
    var status: Int?
    var detail: String?
    var type: String?
    var stacktrace: [String]?
    
    init?(map: Map) {
        
    }
    
    init(title: String?, status: Int, detail: String, type: String, stacktrace: [String]) {
        self.title = title
        self.status = status
        self.detail = detail
        self.type = type
        self.stacktrace = stacktrace
    }
    
    mutating func mapping(map: Map) {
        title <- map["title"]
        status <- map["status"]
        detail <- map["detail"]
        type <- map["type"]
        stacktrace <- map["stacktrace"]
    }
}
