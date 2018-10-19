//
//  Reactive+OAuth2.swift
//  Example
//
//  Created by 王芃 on 2018/10/17.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import RxSwift
import RxCocoa
import p2_OAuth2

extension OAuth2PasswordGrant: ReactiveCompatible {}

extension Reactive where Base: OAuth2PasswordGrant {
    func authorizeWithCredential(username: String, password: String) -> Observable<Void> {
        return Observable<Void>.create{ (observer) -> Disposable in
            self.base.username = username
            self.base.password = password
            self.base.logger = OAuth2DebugLogger(.trace)
            self.base.authorize { json, err in
                if (err != nil) {
                    self.base.forgetTokens()
                    observer.onError(err!)
                } else {
                    observer.onNext(())
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
}
