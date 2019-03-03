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
    static let app = Bundle.main.icon!
    
    static let placeholder = buildIcon(code: "question", font: .fontAwesome, color: .primary)
    static let devices = buildIcon(code: "devices", font: .materialIcon, color: .primary)
    static let manualExecute = buildIcon(code: "play.circle.outline", font: .materialIcon, color: .primary)
    static let homePrimary = buildIcon(code: "home", font: .fontAwesome, color: .primary)
    static let circle = buildIcon(code: "panorama.fish.eye", font: .materialIcon, color: .primary)
    static let social = buildIcon(code: "comments", font: .fontAwesome, color: .black)
    static let user = buildIcon(code: "user", font: .fontAwesome, color: .black)
    static let add = buildIcon(code: "ios-add", font: .ionicon, color: .primary)
    static let lock = buildIcon(code: "ios-lock", font: .ionicon, color: .lightGray)
    static let lockAccent = buildIcon(code: "ios-lock", font: .ionicon, color: .accent)
    static let settingsAccent = buildIcon(code: "ios-cog", font: .ionicon, color: .accent)
    static let sceneHomeAccent = buildIcon(code: "Home", font: .segoeMDL2, color: .accent)
    static let sceneWorkAccent = buildIcon(code: "ParkingLocation", font: .segoeMDL2, color: .accent)
    static let scenePlaceholderAccent = buildIcon(code: "DeviceDiscovery", font: .segoeMDL2, color: .accent)
    static let refreshCircle = buildIcon(code: "ios-aperture", font: .ionicon, color: .accent)
    static let pullToRefresh = buildIcon(code: "angle.double.down", font: .themify, color: .accent)
    static let release = buildIcon(code: "angle.double.up", font: .themify, color: .accent)
    static let eye = buildIcon(code: "ios-eye", font: .ionicon, color: .black)
    static let eyeOff = buildIcon(code: "ios-eye-off", font: .ionicon, color: .black)
    static let clear = buildIcon(code: "clear", font: .materialIcon, color: .black)
    static let devicePlaceholder = buildIcon(code: "nfc", font: .materialIcon, color: .primary)
    static let rightArrow = buildIcon(code: "keyboard.arrow.right", font: .materialIcon, color: .lightGray)
    static let checkCircle = buildIcon(code: "checkcircle", font: .fontAwesome, color: .primary)
    static let uncheckCircle = buildIcon(code: "checkcircle", font: .fontAwesome, color: .lightGray)
    static let mobileIcon = buildIcon(code: "phone.iphone", font: .materialIcon, color: .lightGray)
    
    static let info = buildIcon(code: "info", font: .materialIcon)
    static let warn = buildIcon(code: "warning", font: .materialIcon)
    static let error = buildIcon(code: "error", font: .materialIcon)
//    static let sceneSvg = SVGKFastImageView(svgkImage: SVGKImage(named: "scene"))!
    static let scene = UIImage(named: "scene")!
    static let captchaIcon = buildIcon(code: "ios-lock", font: .ionicon)
    // nav bar icons
    static let barMenu = buildNavIcon(code: "ios-menu", font: .ionicon)
    static let barSettings = buildNavIcon(code: "settings", font: .materialIcon)
    static let barBack = buildNavIcon(code: "navigate.before", font: .materialIcon)
    static let barGroup = buildNavIcon(code: "devices.other", font: .materialIcon)
    static let barNotification = buildNavIcon(code: "notifications.none", font: .materialIcon)
    // sidebar menu icons
    static let menuFamily = buildIcon(code: "group", font: .materialIcon, color: .primary)
    static let menuDevices = buildIcon(code: "router", font: .materialIcon, color: .primary)
    static let menuCamera = buildIcon(code: "photo.camera", font: .materialIcon, color: .primary)
    static let menuMall = buildIcon(code: "shopping.basket", font: .materialIcon, color: .primary)
    static let menuForum = buildIcon(code: "forum", font: .materialIcon, color: .primary)
    static let menuSettings = buildIcon(code: "settings", font: .materialIcon, color: .primary)
    static let menuScenes = buildIcon(code: "landscape", font: .materialIcon, color: .primary)
    static let menuGroups = buildIcon(code: "group.work", font: .materialIcon, color: .primary)
    static func buildNavIcon(
        code: String,
        font: Fonts,
        color: UIColor = .white) -> UIImage {
        return buildIcon(code: code, font: font, color: color, width: 36, height: 36)
    }
    
    static func buildIcon(
        code: String,
        font: Fonts,
        color: UIColor = .white,
        width: CGFloat = 48,
        height: CGFloat = 48,
        backgroundColor: UIColor = .clear) -> UIImage {
        return UIImage(
            from: font,
            code: code,
            textColor: color,
            backgroundColor: backgroundColor,
            size: CGSize(width: width, height: height))
    }
}
