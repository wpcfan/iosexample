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
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        return mutation.debug("mutation") // Use RxSwift's debug() operator
    }
    func transform(state: Observable<State>) -> Observable<State> {
        return state.debug("state") // Use RxSwift's debug() operator
    }
}
#endif
