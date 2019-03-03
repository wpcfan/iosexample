//
//  IndoorAir.swift
//  Example
//
//  Created by 王芃 on 2019/2/14.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import ObjectMapper

class IndoorAir: Mappable {
    required init?(map: Map) {
        humidity <- map["curhum"]
        hcho <- map["curhcho"]
        baoSN <- map["baoSN"]
        co2 <- map["curco2"]
        tvoc <- map["TVOC"]
        pm25 <- map["pm25"]
        temperature <- map["curtemp"]
        pm10 <- map["pm10"]
        noise <- map["Noise"]
        uploadTime <- map["uploadTime"]
    }
    
    func mapping(map: Map) { }
    
    var humidity: String?
    var hcho: String?
    var baoSN: String?
    var co2: String?
    var tvoc: String?
    var pm25: String?
    var temperature: String?
    var pm10: String?
    var noise: String?
    var uploadTime: String?
    var roomGroup: String?
}
