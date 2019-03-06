//
//  Register.swift
//  Example
//
//  Created by 王芃 on 2019/1/21.
//  Copyright © 2019 twigcodes. All rights reserved.
//
import ObjectMapper

class TokenInfo: Mappable {
    
    var token: String?
    var version: Version?
    var splashAd: SplashAd?
    var user: SmartUser?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        token <- map["token"]
        version <- map["versioninfo"]
        splashAd <- map["adinfo"]
        user <- map["userinfo"]
    }
}
