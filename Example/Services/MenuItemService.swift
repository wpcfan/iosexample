//
//  QuestionService.swift
//  Example
//
//  Created by 王芃 on 2019/1/19.
//  Copyright © 2019 twigcodes. All rights reserved.
//


class MenuItemService: LeanCloudBaseService<MenuItem> {
    override var entityPath: String {
        get{
            return "MenuItems"
        }
        set {}
    }
    
}
