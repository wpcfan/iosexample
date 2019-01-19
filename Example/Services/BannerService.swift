//
//  BannerService.swift
//  Example
//
//  Created by 王芃 on 2019/1/19.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import Foundation

class BannerService: LeanCloudBaseService<Banner> {
    private lazy var _entityPath: String = "banners"
    override var entityPath: String {
        get{
            return _entityPath
        }
        set {
            _entityPath = newValue
        }
    }
}
