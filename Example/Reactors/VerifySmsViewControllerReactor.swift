//
//  VerifySmsViewControllerReactor.swift
//  Example
//
//  Created by 王芃 on 2019/2/12.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import RxSwift
import ReactorKit
import Disk

class VerifySmsViewControllerReactor: Reactor {
    private let verifyService = container.resolve(VerifyCapchaService.self)!
    
    enum Action {
        case verifySms(mobile: String, code: String)
    }
    
    enum Mutation {
        case verificationSuccess
        case verificationFail(_ errorMessage: String)
    }
    
    struct State {
        var errorMessage: String? = nil
        var verification: Bool = false
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .verifySms(mobile, code):
            verifyService.phone = mobile
            verifyService.code = code
            return verifyService.request()
                .mapTo(.verificationSuccess)
                .catchError({ (error) -> Observable<Mutation> in
                    Observable.of(.verificationFail(convertErrorToString(error: error)))
                })
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .verificationFail(let message):
            var newState = state
            newState.errorMessage = message
            return newState
        case .verificationSuccess:
            var newState = state
            newState.verification = true
            newState.errorMessage = nil
            return newState
        }
    }
}
