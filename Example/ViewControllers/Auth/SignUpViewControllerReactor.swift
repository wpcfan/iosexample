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

class SignUpViewControllerReactor: Reactor {
    private let tokenService = container.resolve(TokenService.self)!
    private let captchaService = container.resolve(CaptchaService.self)!
    private let verifyService = container.resolve(VerifyCapchaService.self)!
    
    enum Action {
        case getCaptcha
        case verifyCaptcha(mobile: String, code: String)
    }
    
    enum Mutation {
        case getCaptchaSuccess(_ image: UIImage?)
        case getCaptchaFail(_ errorMessage: String)
        case verificationSuccess
        case verificationFail(_ errorMessage: String)
    }
    
    struct State {
        var captcha: UIImage? = nil
        var errorMessage: String? = nil
        var verification: Bool = false
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .getCaptcha:
            return tokenService.handleTokenInfo()
                .flatMapFirst({ (_) -> Observable<UIImage?> in
                     self.captchaService.request()
                })
                .map({ (image: UIImage?) -> Mutation in
                    .getCaptchaSuccess(image)
                })
                .catchError({ (error) -> Observable<Mutation> in
                    Observable.of(.getCaptchaFail(convertErrorToString(error: error)))
                })
        case let .verifyCaptcha(mobile, code):
            verifyService.phone = mobile
            verifyService.code = code
            verifyService.type = "0"
            return verifyService.request()
                .mapTo(.verificationSuccess)
                .catchError({ (error) -> Observable<Mutation> in
                    Observable.of(.verificationFail(convertErrorToString(error: error)))
                })
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .getCaptchaSuccess(let image):
            var newState = state
            newState.captcha = image
            newState.errorMessage = nil
            return newState
        case .verificationFail(let message), .getCaptchaFail(let message):
            var newState = state
            newState.captcha = nil
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
