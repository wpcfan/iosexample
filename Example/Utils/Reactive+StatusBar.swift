//
//  Reactive+StatusBar.swift
//  Example
//
//  Created by 王芃 on 2018/10/23.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import RxSwift
import RxSwiftExt

extension Reactive where Base: UIApplication {
    var keyWindow: Observable<UIWindow?> {
        return NotificationCenter.default.rx
            .notification(UIWindow.didBecomeKeyNotification, object: nil)
            .map { notification -> UIWindow? in
                notification.object as? UIWindow
        }
        .startWith { [weak base] in
            guard let base = base else { return .empty() }
            return .just(base.keyWindow)
        }
    }
    
    var statusBarTap: Observable<Void> {
        return keyWindow
            .flatMapLatest { window -> Observable<CGPoint> in
                guard let window = window else { return .empty() }
                return window.rx
                    .methodInvoked(#selector(UIView.hitTest(_:with:)))
                    .map { args -> CGPoint? in
                        guard args.count == 2,
                            let point = args[0] as? CGPoint,
                            let _ = args[1] as? UIEvent
                            else { return nil}
                        return point
                }
                .unwrap()
        }
        .filter { [unowned app = self.base] point in
            point.y < app.statusBarFrame.maxY + 20
        }
        .void()
        .debounce(0, scheduler: MainScheduler.asyncInstance)
    }
}
