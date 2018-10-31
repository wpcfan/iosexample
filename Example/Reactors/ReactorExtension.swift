//
//  ReactorExtension.swift
//  Example
//
//  Created by 王芃 on 2018/10/31.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import ReactorKit
import RxSwift

#if DEBUG
extension Reactor {
    func transform(action: Observable<Action>) -> Observable<Action> {
        return action.debug("action") // Use RxSwift's debug() operator
    }
    func transform(action: Observable<Mutation>) -> Observable<Mutation> {
        return action.debug("action") // Use RxSwift's debug() operator
    }
}
#endif
