//
//  Shallow+Rx.swift
//  Example
//
//  Created by 王芃 on 2018/10/8.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

//import RxSwift
//import Shallows
//
//public extension Storage {
//
//    public func rx_retrieve(forKey: Key) -> Observable<Any> {
//        return Observable.create{ observer -> Disposable in
//            self.retrieve(forKey: forKey) { result in
//                switch result {
//                case .success(let value):
//                    observer.onNext(value)
//                    observer.onCompleted()
//                case .failure(let error):
//                    observer.onError(error)
//                }
//            }
//            return Disposables.create()
//        }
//    }
//
//    public func rx_set(value: Value, forKey: Key) -> Observable<Bool> {
//        return Observable.create{ (observer) -> Disposable in
//            self.set(value, forKey: forKey) { result in
//                switch result {
//                case .success:
//                    observer.onNext(true)
//                    observer.onCompleted()
//                case .failure(let error):
//                    observer.onError(error)
//                }
//            }
//            return Disposables.create()
//        }
//    }
//}
