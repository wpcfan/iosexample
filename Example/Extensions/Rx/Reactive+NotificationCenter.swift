//
//  Reactive+NotificationCenter.swift
//  Example
//
//  Created by 王芃 on 2018/11/3.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import RxSwift

extension Reactive where Base: NotificationCenter {
    func notification(_ name: AppNotification, object: AnyObject? = nil) -> Observable<Notification> {
        return notification(name.notificationName, object: object)
    }
}
