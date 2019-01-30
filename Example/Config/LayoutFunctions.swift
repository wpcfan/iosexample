//
//  AppLayoutClousures.swift
//  Example
//
//  Created by 王芃 on 2018/10/10.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import Layout

struct LayoutFunctions {
    static let upperCase = { (args: [Any]) throws -> Any in
        guard let string = args.first as? String else {
            throw LayoutError.message("uppercased() function expects a String argument")
        }
        return string.uppercased()
    }
}
