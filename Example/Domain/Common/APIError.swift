//
//  APIError.swift
//  Example
//
//  Created by 王芃 on 2018/10/16.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import ObjectMapper

class APIError: Mappable {
    var title: String?
    var status: Int?
    var detail: String?
    var type: String?
    var stacktrace: [String]?
    
    required init?(map: Map) { }
    
    init(title: String?, status: Int, detail: String, type: String, stacktrace: [String]) {
        self.title = title
        self.status = status
        self.detail = detail
        self.type = type
        self.stacktrace = stacktrace
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        status <- map["status"]
        detail <- map["detail"]
        type <- map["type"]
        stacktrace <- map["stacktrace"]
    }
}

enum SmartError: Error {
    case server(_ code: Int, _ message: String)
    case tokenInvalid(_ message: String)
    case jdAccountNotBinded(_ message: String)
    case jdTokenInvalid(_ message: String)
    case loginInvalid(_ message: String)
}
