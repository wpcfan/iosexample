//
//  EmptyResult.swift
//  Example
//
//  Created by 王芃 on 2019/2/14.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import ObjectMapper

class EmptyResult: Mappable {
    required init?(map: Map) { }
    
    func mapping(map: Map) { }
}
