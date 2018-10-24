//
//  RxUtil.swift
//  Example
//
//  Created by 王芃 on 2018/10/23.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import RxSwift

extension ObservableType {
    func void() -> Observable<Void> {
        return map { _ in }
    }
    func startWith(_ factory: @escaping () -> Observable<E>) -> Observable<E> {
        let start = Observable<E>.deferred {
            factory()
        }
        return start.concat(self)
    }
}
