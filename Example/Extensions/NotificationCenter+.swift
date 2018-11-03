//
//  NotificationCenter+.swift
//  Example
//
//  Created by 王芃 on 2018/11/3.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import UIKit

enum AppNotification: String {
    case jPushAddNotificationCount = "AddNotificationCount"
    case jPushDidRegisterRemoteNotification = "DidRegisterRemoteNotification"
    
    var notificationName: NSNotification.Name {
        return Notification.Name(rawValue: rawValue)
    }
}

extension NotificationCenter {
    static func post(_ name: AppNotification, object: Any? = nil){
        NotificationCenter.default.post(name: name.notificationName, object: object)
    }
}
