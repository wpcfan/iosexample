//
//  OAuth2Rx.swift
//  Example
//
//  Created by 王芃 on 2018/10/8.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import Foundation
import RxSwift
import p2_OAuth2

extension OAuth2 {
    open func rx_authorize() -> Observable<OAuth2JSON> {
        return Observable<OAuth2JSON>.create{ (observer: AnyObserver<OAuth2JSON>) -> Disposable in
            self.authorize(){ (jsonRes, oauth2Error) in
                if(oauth2Error == nil) {
                    observer.onNext(jsonRes!)
                    observer.onCompleted()
                } else {
                    observer.onError(oauth2Error!)
                }
            }
            // else an error has been thrown
            return Disposables.create {
                self.abortAuthorization()
            }
            }.share()
    }
}
