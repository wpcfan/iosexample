//
//  AuthViewReactor.swift
//  Example
//
//  Created by 王芃 on 2018/10/17.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import RxSwift
import ReactorKit
import Moya_ObjectMapper

class AuthViewControllerReactor: Reactor {
    let oauthService = container.resolve(OAuth2Service.self)!
    enum Action {
        case login(username: String, password: String)
        case loginSuccess
        case loginFail
    }
    
    struct State {
        var loggedIn: Bool = false
        var logging: Bool = false
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Action> {
        switch action {
        case let .login(username, password):
            return
                oauthService.loginWithUserCredential(username: username, password: password)
                .map { _ -> Action in
                    Action.loginSuccess
                }
                .do(onNext: { (_) in
                    AppDelegate.shared.rootViewController.switchToMainScreen()
                })
                .debug()
                .catchErrorJustReturn(Mutation.loginFail)
        default:
            return Observable.of(action)
        }
    }
    
    func reduce(state: State, mutation: Action) -> State {
        switch mutation {
        case .loginSuccess:
            var newState = state
            newState.loggedIn = true
            newState.logging = false
            return newState
        case .loginFail:
            var newState = state
            newState.loggedIn = false
            newState.logging = false
            return newState
        case .login(_, _):
            var newState = state
            newState.logging = true
            return newState
        }
    }
}
