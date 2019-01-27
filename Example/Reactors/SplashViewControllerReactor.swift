//
//  SplashViewControllerReactor.swift
//  Example
//
//  Created by 王芃 on 2018/10/27.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import RxSwift
import ReactorKit
import URLNavigator
import Shallows

class SplashViewControllerReactor: Reactor {
    private let storage = container.resolve(Storage<Filename, AppData>.self)!
    private let oauth2Service = container.resolve(OAuth2Service.self)!
    private let registerService = container.resolve(RegisterService.self)!
    
    enum NavTarget {
        case login
        case main
        case tour
    }
    
    enum Action {
        case tick
        case checkFirstLaunch
        case checkRegister
    }
    
    enum Mutation {
        case setTick
        case setNavTarget(target: NavTarget)
        case setDeviceToken(_ status: Bool)
    }
    
    struct State {
        var countDown: Int
        var nav: NavTarget
        var deviceTokenReady: Bool
    }
    
    let initialState: State = State(countDown: 5, nav: .login, deviceTokenReady: false)
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .checkFirstLaunch:
            return self.storage
                .rx_retrieve(forKey: Filename(rawValue: Constants.APP_DATA_KEY))
                .debug()
                .flatMap { (val) -> Observable<Mutation> in
                    let result = val as? AppData
                    let tourPresented = result?.tourGuidePresented ?? false
                    if (tourPresented) {
                        return Observable.of(self.oauth2Service.checkLoginStatus())
                            .debug()
                            .map{ (auth) -> Mutation in
                                if (auth) {
                                    return .setNavTarget(target: .main)
                                } else {
                                    return .setNavTarget(target: .login)
                                }
                            }
                    } else {
                        return Observable.of(.setNavTarget(target: .tour))
                    }
                }
                .catchErrorJustReturn(.setNavTarget(target: .tour))
        case .tick:
            return Observable.of(.setTick)
        case .checkRegister:
            return self.storage.rx_retrieve(forKey: Filename(rawValue: Constants.APP_DATA_KEY))
                .debug()
                .flatMapLatest({ (appData) -> Observable<Bool> in
                    guard let result = appData as? AppData, result.token == nil else { return Observable.of(true)}
                    
                    return self.registerService.request()
                        .flatMapLatest({ (register: Register) -> Observable<Bool> in
                            var newAppData = result
                            newAppData.token = register.token
                            return self.storage.rx_set(value: newAppData, forKey: Filename(rawValue: Constants.APP_DATA_KEY))
                        })
                }).map({ (status) -> Mutation in
                    .setDeviceToken(status)
                })
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .setTick:
            var newState = state
            newState.countDown -= 1
            return newState
        case .setNavTarget(let target):
            var newState = state
            newState.nav = target
            return newState
        case .setDeviceToken(let status):
            var newState = state
            newState.deviceTokenReady = status
            return newState
        }
    }
}
