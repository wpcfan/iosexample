//
//  AuthViewReactor.swift
//  Example
//
//  Created by 王芃 on 2018/10/17.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import RxSwift
import ReactorKit
import Shallows

class AuthViewControllerReactor: Reactor {
    let oauthService = container.resolve(OAuth2Service.self)!
    let loginService = container.resolve(LoginService.self)!
    let storage = container.resolve(Storage<Filename, SmartUser>.self)!
    enum Action {
        case login(username: String, password: String)
    }
    
    enum Mutation {
        case loginSuccess
        case loginFail(_ message: String)
        case loading(_ status: Bool)
    }
    
    struct State {
        var loggedIn: Bool = false
        var loading: Bool = false
        var errorMessage: String?
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .login(username, password):
            loginService.mobile = username
            loginService.password = password
            return loginService.request().flatMapLatest{ user -> Observable<Bool> in
                return self.storage
                    .rx_set(value: user, forKey: Filename(rawValue: Constants.SMART_USER_DATA_KEY))
                    .catchError({ (err) -> Observable<Bool> in
                        print("Error persisting user data \(err)")
                        return Observable.of(false)
                    })
                }.map { _ -> Mutation in .loginSuccess }
                .do(onNext: { (_) in
                    DispatchQueue.main.async {
                        AppDelegate.shared.rootViewController.switchToMainScreen()
                    }
                })
                .debug()
                .catchError{ error -> Observable<Mutation>  in
                    Observable.of(.loginFail(convertErrorToString(error: error)))
            }
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        return Observable.merge(mutation, loginService.loading.map(Mutation.loading))
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .loginSuccess:
            var newState = state
            newState.loggedIn = true
            newState.loading = false
            return newState
        case .loginFail(let message):
            var newState = state
            newState.loggedIn = false
            newState.loading = false
            newState.errorMessage = message
            return newState
        case .loading(let status):
            var newState = state
            newState.loading = status
            newState.errorMessage = ""
            return newState
        }
    }
}
