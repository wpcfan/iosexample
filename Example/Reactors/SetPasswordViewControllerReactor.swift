//
//  SetPasswordViewControllerReactor.swift
//  Example
//
//  Created by 王芃 on 2019/2/12.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import RxSwift
import ReactorKit

class SetPasswordViewControllerReactor: Reactor {
    private let passwordService = container.resolve(SetPasswordService.self)!
    
    enum Action {
        case setPassword(mobile: String, password: String)
    }
    
    enum Mutation {
        case setPasswordSuccess(_ user: SmartUser?)
        case setPasswordFail(_ errorMessage: String)
    }
    
    struct State {
        var errorMessage: String? = nil
        var user: SmartUser? = nil
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .setPassword(mobile, code):
            passwordService.phone = mobile
            passwordService.password = code
            return passwordService.request()
                .map { user in .setPasswordSuccess(user)}
                .catchError({ (error) -> Observable<Mutation> in
                    Observable.of(.setPasswordFail(convertErrorToString(error: error)))
                })
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .setPasswordFail(let message):
            var newState = state
            newState.user = nil
            newState.errorMessage = message
            return newState
        case .setPasswordSuccess(let user):
            var newState = state
            newState.user = user
            newState.errorMessage = nil
            return newState
        }
    }
}
