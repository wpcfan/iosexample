//
//  JdProduct.swift
//  Example
//
//  Created by 王芃 on 2019/3/6.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import ObjectMapper

class JdProduct: Mappable {
    var id: Int?
    var desc: String?
    var name: String?
    var configType: Int?
    var lancon: String?
    var isShowResetJoinnet: Bool?
    var type: Int?
    var shareFlag: Int?
    var supportAFS: Int?
    var templateType: String?
    var categoryId: Int?
    var protocolVersion: String?
    var productUUID: String?
    var typeDesc: String?
    var imageUrl: String?
    var typeName: String?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        isShowResetJoinnet <- map["is_show_resetjoinnet"]
        desc <- map["p_description"]
        lancon <- map["lancon"]
        id <- map["product_id"]
        configType <- map["config_type"]
        name <- map["product_name"]
        type <- map["pro_type"]
        shareFlag <- map["share_flag"]
        supportAFS <- map["supportAFS"]
        templateType <- map["template_type"]
        categoryId <- map["cid"]
        protocolVersion <- map["protocol_version"]
        productUUID <- map["product_uuid"]
        typeDesc <- map["type_desc"]
        imageUrl <- map["p_img_url"]
        typeName <- map["type_name"]
    }
}
