//
//  Product.swift
//  Example
//
//  Created by 王芃 on 2018/10/12.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import ObjectMapper

class Product: Mappable {
    var id: String?
    var name: String?
    var imageUrl: String?
    var brand: String?
    var version: Int?
    var models: Array<String>?
    var category: ProductCategory?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        imageUrl <- map["image"]
        version <- map["version"]
        brand <- map["brand"]
        models <- map["models"]
        category <- map["category"]
    }
}
