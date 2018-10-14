//
//  AppIcons.swift
//  Example
//
//  Created by 王芃 on 2018/10/10.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import UIKit
import SwiftIconFont

struct AppIcons {
    static let DEFAULT_ICON_WIDTH = 48
    static let DEFAULT_ICON_HEIGHT = 48
    
    static let tabHome = UIImage(
        from: .fontAwesome,
        code: "home",
        textColor: .black,
        backgroundColor: .clear,
        size: CGSize(width: DEFAULT_ICON_WIDTH, height: DEFAULT_ICON_HEIGHT))
    
    static let tabSocial = UIImage(
        from: .fontAwesome,
        code: "comments",
        textColor: .black,
        backgroundColor: .clear,
        size: CGSize(width: DEFAULT_ICON_WIDTH, height: DEFAULT_ICON_HEIGHT))
    
    static let tabMy = UIImage(
        from: .fontAwesome,
        code: "user",
        textColor: .black,
        backgroundColor: .clear,
        size: CGSize(width: DEFAULT_ICON_WIDTH, height: DEFAULT_ICON_HEIGHT))
    
    static let btnAdd = UIImage(
        from: .ionicon,
        code: "ios-add",
        textColor: .white,
        backgroundColor: .clear,
        size: CGSize(width: DEFAULT_ICON_WIDTH, height: DEFAULT_ICON_HEIGHT))
}
