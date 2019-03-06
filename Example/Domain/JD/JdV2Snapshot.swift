//
//  SCV2Snapshot.swift
//  Example
//
//  Created by 王芃 on 2019/2/14.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import ObjectMapper

class JdV2Snapshot: Mappable {
    var status: String?
    var digest: String?
    var streams: [JdStream]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        digest <- map["digest"]
        streams <- map["streams"]
    }
    
    func toDictionary() -> Dictionary<String, JdStream> {
        return (streams ?? []).keyBy({ (stream) -> String in
            stream.id!
        })
    }
    
    func toPlainDict() -> Dictionary<String, String> {
        return toDictionary().valuesMapped({ (stream) -> String in
            stream.value ?? ""
        })
    }
}
