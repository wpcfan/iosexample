//
//  Weather.swift
//  Example
//
//  Created by 王芃 on 2019/2/14.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import ObjectMapper

struct Weather: Mappable {
    var location: String?
    var temperature: String?
    var humidity: String?
    var pm25: String?
    var windDirection: String?
    var windForce: String?
    var phenomena: String?
    var airQualityIndicator: String?
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        location <- map["cname"]
        temperature <- map["w_temp"]
        windDirection <- map["w_direction"]
        pm25 <- map["pm25"]
        humidity <- map["w_humidity"]
        windForce <- map["w_force"]
        phenomena <- map["w_phenomena"]
        airQualityIndicator <- map["aqi"]
    }
}
