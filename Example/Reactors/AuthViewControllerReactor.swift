//
//  AuthViewReactor.swift
//  Example
//
//  Created by 王芃 on 2018/10/17.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import RxSwift
import ReactorKit
import Disk

class AuthViewControllerReactor: Reactor {
    //    let oauthService = container.resolve(OAuth2Service.self)!
    private let loginService = container.resolve(LoginService.self)!
    private let tokenService = container.resolve(TokenService.self)!
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
            return self.tokenService.handleTokenInfo()
                .flatMapLatest { (_) -> Observable<Mutation> in
                    self.loginService.mobile = username
                    self.loginService.password = password
                    return self.loginService.request()
                        .do(onNext: { user in
                            var data = try Disk.retrieve(Constants.APP_DATA_PATH, from: .documents, as: AppData.self)
                            data.user = user
                            try Disk.save(data, to: .documents, as: Constants.APP_DATA_PATH)
                            CURRENT_USER.onNext(user)
                        })
                        .map { _ -> Mutation in .loginSuccess }
                        .do(onNext: { (_) in
                            DispatchQueue.main.async {
                                AppDelegate.shared.rootViewController.switchToHome()
                            }
                        })
                        .debug()
                        .catchError{ error -> Observable<Mutation>  in
                            Observable.of(.loginFail(convertErrorToString(error: error)))
                    }
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
