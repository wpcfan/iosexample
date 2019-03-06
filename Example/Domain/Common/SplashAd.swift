//
//  SplashAd.swift
//  Example
//
//  Created by 王芃 on 2019/2/14.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import ObjectMapper

class SplashAd: Codable, Mappable {
    var imageUrl: String?
    var link: String?
    var id: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        imageUrl <- map["adurl"]
        link <- map["redirecturl"]
        id <- map["id"]
    }
}
