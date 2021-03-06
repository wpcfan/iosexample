//
//  Banner.swift
//  Example
//
//  Created by 王芃 on 2018/10/11.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import ObjectMapper
import RxDataSources

struct Banner: Mappable {
    
    var objectId: String?
    var imageUrl: String?
    var label: String?
    var link: String?
    init?(map: Map) {
        
    }
    
    init(id: String?, imageUrl: String, label: String, link: String) {
        self.objectId = id
        self.imageUrl = imageUrl
        self.label = label
        self.link = link
    }
    
    mutating func mapping(map: Map) {
        objectId <- map["objectId"]
        imageUrl <- map["imageUrl"]
        label <- map["label"]
        link <- map["link"]
    }
    
    var id: String? {
        get {
            return objectId
        }
    }
}
