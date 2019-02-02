//
//  AppIcons.swift
//  Example
//
//  Created by 王芃 on 2018/10/10.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import UIKit
import SwiftIconFont
import SVGKit

struct AppIcons {
    static let DEFAULT_ICON_WIDTH = 48
    static let DEFAULT_ICON_HEIGHT = 48
    
    static let app = Bundle.main.icon!
    
    static let home = UIImage(
        from: .fontAwesome,
        code: "home",
        textColor: .primary,
        backgroundColor: .clear,
        size: CGSize(width: DEFAULT_ICON_WIDTH, height: DEFAULT_ICON_HEIGHT))
    
    static let social = UIImage(
        from: .fontAwesome,
        code: "comments",
        textColor: .black,
        backgroundColor: .clear,
        size: CGSize(width: DEFAULT_ICON_WIDTH, height: DEFAULT_ICON_HEIGHT))
    
    static let user = UIImage(
        from: .fontAwesome,
        code: "user",
        textColor: .black,
        backgroundColor: .clear,
        size: CGSize(width: DEFAULT_ICON_WIDTH, height: DEFAULT_ICON_HEIGHT))
    
    static let add = UIImage(
        from: .ionicon,
        code: "ios-add",
        textColor: .white,
        backgroundColor: .clear,
        size: CGSize(width: DEFAULT_ICON_WIDTH, height: DEFAULT_ICON_HEIGHT))
    
    static let lock = UIImage(
        from: .ionicon,
        code: "ios-lock",
        textColor: .white,
        backgroundColor: .clear,
        size: CGSize(width: DEFAULT_ICON_WIDTH, height: DEFAULT_ICON_HEIGHT))
    
    static let lockAccent = UIImage(
        from: .ionicon,
        code: "ios-lock",
        textColor: UIColor.accent,
        backgroundColor: .clear,
        size: CGSize(width: DEFAULT_ICON_WIDTH, height: DEFAULT_ICON_HEIGHT))
    
    static let settingsAccent = UIImage(
        from: .ionicon,
        code: "ios-cog",
        textColor: UIColor.accent,
        backgroundColor: .clear,
        size: CGSize(width: DEFAULT_ICON_WIDTH, height: DEFAULT_ICON_HEIGHT))
    
    static let sceneHomeAccent = UIImage(
        from: .segoeMDL2,
        code: "Home",
        textColor: UIColor.accent,
        backgroundColor: .clear,
        size: CGSize(width: DEFAULT_ICON_WIDTH, height: DEFAULT_ICON_HEIGHT))
    
    static let sceneWorkAccent = UIImage(
        from: .segoeMDL2,
        code: "ParkingLocation",
        textColor: UIColor.accent,
        backgroundColor: .clear,
        size: CGSize(width: DEFAULT_ICON_WIDTH, height: DEFAULT_ICON_HEIGHT))
    
    static let scenePlaceholderAccent = UIImage(
        from: .segoeMDL2,
        code: "DeviceDiscovery",
        textColor: UIColor.accent,
        backgroundColor: .clear,
        size: CGSize(width: DEFAULT_ICON_WIDTH, height: DEFAULT_ICON_HEIGHT))
    
    static let refreshCircle = UIImage(
        from: .ionicon,
        code: "ios-aperture",
        textColor: .accent,
        backgroundColor: .clear,
        size: CGSize(width: DEFAULT_ICON_WIDTH, height: DEFAULT_ICON_HEIGHT))
    
    static let pullToRefresh = UIImage(
        from: .themify,
        code: "angle.double.down",
        textColor: .accent,
        backgroundColor: .clear,
        size: CGSize(width: DEFAULT_ICON_WIDTH, height: DEFAULT_ICON_HEIGHT))
    
    static let release = UIImage(
        from: .themify,
        code: "angle.double.up",
        textColor: .accent,
        backgroundColor: .clear,
        size: CGSize(width: DEFAULT_ICON_WIDTH, height: DEFAULT_ICON_HEIGHT))
    
    static let menu = UIImage(
        from: .ionicon,
        code: "ios-menu",
        textColor: UIColor.white,
        backgroundColor: .clear,
        size: CGSize(width: DEFAULT_ICON_WIDTH, height: DEFAULT_ICON_HEIGHT))
    
    static let eye = UIImage(
        from: .ionicon,
        code: "ios-eye",
        textColor: .black,
        backgroundColor: .clear,
        size: CGSize(width: DEFAULT_ICON_WIDTH, height: DEFAULT_ICON_HEIGHT))
    
    static let eyeOff = UIImage(
        from: .ionicon,
        code: "ios-eye-off",
        textColor: .black,
        backgroundColor: .clear,
        size: CGSize(width: DEFAULT_ICON_WIDTH, height: DEFAULT_ICON_HEIGHT))
    
    static let clear = UIImage(
        from: .materialIcon,
        code: "clear",
        textColor: .black,
        backgroundColor: .clear,
        size: CGSize(width: DEFAULT_ICON_WIDTH, height: DEFAULT_ICON_HEIGHT))
    
    static let devicePlaceholder = UIImage(
        from: .materialIcon,
        code: "nfc",
        textColor: .primary,
        backgroundColor: .clear,
        size: CGSize(width: DEFAULT_ICON_WIDTH, height: DEFAULT_ICON_HEIGHT))
    
    static let checkCircle = UIImage(
        from: .fontAwesome,
        code: "checkcircle",
        textColor: .primary,
        backgroundColor: .clear,
        size: CGSize(width: DEFAULT_ICON_WIDTH, height: DEFAULT_ICON_HEIGHT))
    
//    static let sceneSvg = SVGKFastImageView(svgkImage: SVGKImage(named: "scene"))!
    static let scene = UIImage(named: "scene")
}
