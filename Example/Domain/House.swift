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
    var houseNo: String?
    var location: String?
    var projectName: String?
    
    init?(map: Map) {
        
    }
    
    init(id: String?, houseNo: String, location: String, projectName: String) {
        self.id = id
        self.houseNo = houseNo
        self.location = location
        self.projectName = projectName
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        houseNo <- map["houseNo"]
        location <- map["location"]
        projectName <- map["projectName"]
    }
}
