//
//  AppAttributedStrings.swift
//  Example
//
//  Created by 王芃 on 2018/10/10.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import UIKit

#if swift(>=4.2)
let foregroundColorKey = NSAttributedString.Key.foregroundColor
let fontKey = NSAttributedString.Key.font
#elseif swift(>=4)
let foregroundColorKey = NSAttributedStringKey.foregroundColor
let fontKey = NSAttributedStringKey.font
#else
let foregroundColorKey = NSForegroundColorAttributeName
let fontKey = NSFontAttributeName
#endif

struct AppAttributedStrings {
    static let copyrightString = NSAttributedString(
        string: "\u{2103}",
        attributes: [foregroundColorKey: UIColor.red, fontKey: UIFont.systemFont(ofSize: 12)]
    )
}
