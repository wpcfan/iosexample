//
//  BindJdAccountViewControllerReactor.swift
//  Example
//
//  Created by 王芃 on 2019/2/13.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import RxSwift
import ReactorKit

class BindJdAccountViewControllerReactor: Reactor {
    private let bindAccountService = container.resolve(BindAccountService.self)!
    
    enum Action {
        case bindAccount(code: String)
    }
    
    enum Mutation {
        case bindSuccess(_ user: SmartUser?)
        case bindFail(_ errorMessage: String)
    }
    
    struct State {
        var errorMessage: String? = nil
        var user: SmartUser? = nil
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .bindAccount(code):
            bindAccountService.code = code
            return bindAccountService.request()
                .map { user in .bindSuccess(user)}
                .catchError({ (error) -> Observable<Mutation> in
                    Observable.of(.bindFail(convertErrorToString(error: error)))
                })
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .bindFail(let message):
            var newState = state
            newState.user = nil
            newState.errorMessage = message
            return newState
        case .bindSuccess(let user):
            var newState = state
            newState.user = user
            newState.errorMessage = nil
            return newState
        }
    }
}
