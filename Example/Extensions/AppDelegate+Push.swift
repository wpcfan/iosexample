//
//  AppDelegate+JPush.swift
//  Example
//
//  Created by 王芃 on 2018/11/2.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import UIKit

#if TARGET_CPU_ARM
// 极光消息集成
// 如果实现 JPUSHRegisterDelegate 则不用实现 UNUserNotificationCenterDelegate
extension AppDelegate: JPUSHRegisterDelegate {
    
    // 处理自定义消息
    @objc func networkDidReceiveMessage(_ notification: Notification) -> Void {
        let userInfo = notification.userInfo
        guard userInfo != nil else {
            return
        }
        let content = userInfo!["content"].value as! String
        let messageID = userInfo!["_j_msgid"].value as! Int
        let extras = (userInfo!["extras"]) as? Dictionary<String, String>
        
        print("[JPush][自定义消息] 消息 ID： \(messageID)")
        print("[JPush][自定义消息] 内容： \(content)")
        print("[JPush][自定义消息] 自定义字段 \(String(describing: extras))")
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification?) {
        if ((notification != nil) && (notification!.request.trigger?.isKind(of: UNPushNotificationTrigger.self))!) {
            //从通知界面直接进入应用
            print("entering")
        } else {
            //从通知设置界面进入应用
        }
    }
    
    // 应用在后台时，处理通知逻辑
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        
        let userInfo = response.notification.request.content.userInfo
        
        let request = response.notification.request // 收到推送的请求
        let content = request.content // 收到推送的消息内容
        let badge = content.badge // 推送消息的角标
        let body = content.body   // 推送消息体
        let sound = content.sound // 推送消息的声音
        let subtitle = content.subtitle // 推送消息的副标题
        let title = content.title // 推送消息的标题
        if ((response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))!) {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        
        print("[JPush][APN][后台] 参数： \(userInfo)")
        print("[JPush][APN][后台] 内容： \(content)")
        print("[JPush][APN][后台] 标题： \(title)")
        print("[JPush][APN][后台] 副标题： \(subtitle)")
        print("[JPush][APN][后台] 声音： \(String(describing: sound))")
        print("[JPush][APN][后台] 角标： \(String(describing: badge))")
        print("[JPush][APN][后台] 消息体： \(body)")
        // 通知栏消息弹出
        completionHandler()
    }
    
    // 应用在前台时，处理通知逻辑
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!,
                                 withCompletionHandler completionHandler: (Int) -> Void) {
        let userInfo = notification.request.content.userInfo
        let request = notification.request // 收到推送的请求
        let content = request.content // 收到推送的消息内容
        let badge = content.badge // 推送消息的角标
        let body = content.body   // 推送消息体
        let sound = content.sound // 推送消息的声音
        let subtitle = content.subtitle // 推送消息的副标题
        let title = content.title // 推送消息的标题
        if ((notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))!) {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        
        print("[JPush][APN][前台] 参数： \(userInfo)")
        print("[JPush][APN][前台] 内容： \(content)")
        print("[JPush][APN][前台] 标题： \(title)")
        print("[JPush][APN][前台] 副标题： \(subtitle)")
        print("[JPush][APN][前台] 声音： \(String(describing: sound))")
        print("[JPush][APN][前台] 角标： \(String(describing: badge))")
        print("[JPush][APN][前台] 消息体： \(body)")
        // 通知栏消息弹出
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
    }
    
    // IOS Notification Handling
    
    func clearNotification(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        application.cancelAllLocalNotifications()
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("[JPush][注册 Token] \(String(describing: deviceToken))")
        NotificationCenter.post(.jPushDidRegisterRemoteNotification, object: deviceToken)
        JPUSHService.registerDeviceToken(deviceToken)
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        printError("[JPush][注册 Token] 失败 \(String(describing: error))")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        JPUSHService.handleRemoteNotification(userInfo)
        print("[JPush] 收到通知 \(userInfo)")
        NotificationCenter.post(.jPushAddNotificationCount)
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        // for iOS version < 10
        JPUSHService.showLocalNotification(atFront: notification, identifierKey: nil)
    }
    
    @available(iOS 9, *)
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        
    }
    
    @available(iOS 9, *)
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        
    }
    
    @available(iOS 9, *)
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable: Any], withResponseInfo responseInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
        
    }
}
#endif

extension AppDelegate {
    /// 极光服务初始化
    func setupPushNotification(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        #if TARGET_CPU_ARM
        if #available(iOS 10, *) {
            let entity = JPUSHRegisterEntity()
            entity.types = NSInteger(UNAuthorizationOptions.alert.rawValue) |
                NSInteger(UNAuthorizationOptions.sound.rawValue) |
                NSInteger(UNAuthorizationOptions.badge.rawValue)
            JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        }  else {
            // 可以自定义 categories
            JPUSHService.register(
                forRemoteNotificationTypes: UIUserNotificationType.badge.rawValue |
                    UIUserNotificationType.sound.rawValue |
                    UIUserNotificationType.alert.rawValue,
                categories: nil)
        }
        let channel = "App Store"
        var isProd = true
        #if DEBUG
        isProd = false
        #endif
        JPUSHService.setup(withOption: launchOptions, appKey: AppEnv.pushKey, channel: channel, apsForProduction: isProd)
        #if DEBUG
        JPUSHService.setDebugMode()
        #else
        JPUSHService.setLogOFF()
        #endif
        let defaultCenter = NotificationCenter.default
        // 订阅自定义消息
        defaultCenter.addObserver(self,
                                  selector: #selector(networkDidReceiveMessage(_:)),
                                  name: NSNotification.Name.jpfNetworkDidReceiveMessage,
                                  object: nil)
        #endif
    }
}
