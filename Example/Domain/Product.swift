//
//  Product.swift
//  Example
//
//  Created by 王芃 on 2018/10/12.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import ObjectMapper

struct Product: Mappable {
    var id: String?
    var name: String?
    var imageUrl: String?
    var brand: String?
    var version: Int?
    var models: Array<String>?
    var category: ProductCategory?
    
    init?(map: Map) {
        
    }
    
    init(id: String?, name: String, imageUrl: String, brand: String, version: Int, models: Array<String> = [], category: ProductCategory) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
        self.brand = brand
        self.version = version
        self.models = models
        self.category = category
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        imageUrl <- map["imageUrl"]
        version <- map["version"]
        brand <- map["brand"]
        models <- map["models"]
        category <- map["category"]
    }
    
}
