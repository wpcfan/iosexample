//
//  UIApplication+.swift
//  Example
//
//  Created by 王芃 on 2018/11/12.
//  Copyright © 2018 twigcodes. All rights reserved.
//

#if swift(>=4.2)
extension UIApplication {
    typealias LaunchOptionsKey = UIApplication.LaunchOptionsKey
}
#else
extension UIApplication {
    typealias LaunchOptionsKey = UIApplicationLaunchOptionsKey
}
#endif
