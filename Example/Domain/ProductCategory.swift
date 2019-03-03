//
//  ProductCategory.swift
//  Example
//
//  Created by 王芃 on 2018/10/12.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import ObjectMapper

class ProductCategory: Mappable {
    var id: String?
    var name: String?
    var imageUrl: String?
    
    required init?(map: Map) { }
    
    init(id: String?, name: String, imageUrl: String) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        imageUrl <- map["imageUrl"]
    }
}
