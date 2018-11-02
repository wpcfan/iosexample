//
//  AppDelegate+JPush.swift
//  Example
//
//  Created by 王芃 on 2018/11/2.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import UIKit

// for JPush integration
extension AppDelegate: JPUSHRegisterDelegate {
    
    func setupPushNotification(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        if #available(iOS 10, *) {
            let entity = JPUSHRegisterEntity()
            entity.types = NSInteger(UNAuthorizationOptions.alert.rawValue) |
                NSInteger(UNAuthorizationOptions.sound.rawValue) |
                NSInteger(UNAuthorizationOptions.badge.rawValue)
            JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
            UNUserNotificationCenter.current().delegate = self
        }  else {
            // 可以自定义 categories
            JPUSHService.register(
                forRemoteNotificationTypes: UIUserNotificationType.badge.rawValue |
                    UIUserNotificationType.sound.rawValue |
                    UIUserNotificationType.alert.rawValue,
                categories: nil)
        }
        let channel = "App Store"
        JPUSHService.setup(withOption: launchOptions, appKey: AppEnv.pushKey, channel: channel, apsForProduction: false)
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification?) {
        if ((notification != nil) && (notification!.request.trigger?.isKind(of: UNPushNotificationTrigger.self))!) {
            //从通知界面直接进入应用
            log.debug("entering")
        } else {
            //从通知设置界面进入应用
        }
    }
    
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        
        let userInfo = response.notification.request.content.userInfo
        let request = response.notification.request // 收到推送的请求
        let content = request.content // 收到推送的消息内容
        log.debug("receive message \(content)")
        let badge = content.badge // 推送消息的角标
        let body = content.body   // 推送消息体
        let sound = content.sound // 推送消息的声音
        let subtitle = content.subtitle // 推送消息的副标题
        let title = content.title // 推送消息的标题
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!,
                                 withCompletionHandler completionHandler: ((Int) -> Void)!) {
        let userInfo = notification.request.content.userInfo
        
        let request = notification.request // 收到推送的请求
        let content = request.content // 收到推送的消息内容
        log.debug("receive message \(content)")
        let badge = content.badge // 推送消息的角标
        let body = content.body   // 推送消息体
        let sound = content.sound // 推送消息的声音
        let subtitle = content.subtitle // 推送消息的副标题
        let title = content.title // 推送消息的标题
    }
    
    // IOS Notification Handling
    
    func clearNotification(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        application.cancelAllLocalNotifications()
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        log.debug("get the deviceToken  \(deviceToken)")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "DidRegisterRemoteNotification"), object: deviceToken)
        JPUSHService.registerDeviceToken(deviceToken)
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        log.error("did fail to register for remote notification with error" + error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        JPUSHService.handleRemoteNotification(userInfo)
        log.debug("收到通知 \(userInfo)")
        //        NotificationCenter.default.rx.notification(Notification.Name(rawValue: "AddNotificationCount"), object: nil)
        //            .subscribe{ log.debug("received notification") }
        //            .disposed(by: self.disposeBag)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "AddNotificationCount"), object: nil)
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

extension AppDelegate: UNUserNotificationCenterDelegate {
    // Handle notification when app is foreground
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
    }
}
