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
import Disk

class SplashViewControllerReactor: Reactor {
    private let tokenService = container.resolve(TokenService.self)!
    enum NavTarget {
        case login
        case main
        case tour
        case bindJdAccount
    }
    
    enum Action {
        case tick
        case checkFirstLaunch
    }
    
    enum Mutation {
        case setTick
        case setNavTarget(target: NavTarget)
    }
    
    struct State {
        var countDown: Int
        var nav: NavTarget
    }
    
    let initialState: State = State(countDown: 5, nav: .login)
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .checkFirstLaunch:
            let result = try? Disk.retrieve(Constants.APP_DATA_PATH, from: .documents, as: AppData.self)
            let tourPresented = result?.tourGuidePresented ?? false
            if (tourPresented) {
                return (result?.user) != nil && result?.token != nil ?
                    result!.user!.jdAccountBinded ?? false ?
                        self.tokenService.handleTokenInfo().mapTo(.setNavTarget(target: .main)) :
                        Observable.of(.setNavTarget(target: .bindJdAccount)) :
                    Observable.of(.setNavTarget(target: .login))
            } else {
                return Observable.of(.setNavTarget(target: .tour))
            }
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
        }
    }
}
