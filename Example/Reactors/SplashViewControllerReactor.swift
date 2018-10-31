//
//  SplashViewControllerReactor.swift
//  Example
//
//  Created by 王芃 on 2018/10/27.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import RxSwift
import ReactorKit
import Moya_ObjectMapper
import Moya
import URLNavigator
import Shallows

class SplashViewControllerReactor: Reactor {
    private let storage = container.resolve(Storage<Filename, AppData>.self)!
    private let oauth2Service = container.resolve(OAuth2Service.self)!
    
    enum NavTarget {
        case login
        case main
        case tour
    }
    
    enum Action {
        case tick
        case checkFirstLaunch
    }
    
    enum Mutation {
        case setTick
        case setTour
        case setNavTarget(target: NavTarget)
    }
    
    struct State {
        var countDown: Int
        var nav: NavTarget
        var tourPresented: Bool
    }
    
    let initialState: State = State(countDown: 5, nav: .login, tourPresented: false)
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .checkFirstLaunch:
            return self.storage
                .rx_retrieve(forKey: "data")
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
        case .setTour:
            var newState = state
            newState.tourPresented = true
            return newState
        }
    }
}
