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
    }
    
    enum Mutation {
        case loginSuccess
        case loginFail
    }
    
    struct State {
        var loggedIn: Bool = false
        var logging: Bool = false
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .login(username, password):
            return
                oauthService.loginWithUserCredential(username: username, password: password)
                    .map { _ -> Mutation in .loginSuccess }
                    .do(onNext: { (_) in
                        AppDelegate.shared.rootViewController.switchToMainScreen()
                    })
                    .debug()
                    .catchErrorJustReturn(.loginFail)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
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
        }
    }
}
