//
//  House.swift
//  Example
//
//  Created by 王芃 on 2018/10/12.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import ObjectMapper
import RxDataSources

struct House: Mappable {
    var id: String?
    var projectId: String?
    var projectName: String?
    var stage: String?
    var houseNo: String?
    var unitNo: String?
    var roomNo: String?
    var isOwner: Bool?
    var jdAccessToken: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        projectId <- map["pid"]
        projectName <- map["pname"]
        stage <- map["stage"]
        houseNo <- map["num"]
        unitNo <- map["unitno"]
        roomNo <- map["roomnum"]
        isOwner <- map["isOwner"]
        jdAccessToken <- map["accessToken"]
    }
}
