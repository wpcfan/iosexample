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
        case navigateTo
        case checkFirstLaunch
        case checkAuth
    }
    
    enum Mutation {
        case setTick
        case setTour
        case setNaviTarget(target: NavTarget)
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
                .map { (val) -> Mutation in
                    let result = val as? AppData
                    let tourPresented = result?.tourGuidePresented ?? false
                    if (tourPresented) {
                        return Mutation.setTour
                    } else {
                        return Mutation.setNaviTarget(target: .tour)
                    }
                }
                .catchErrorJustReturn(Mutation.setNaviTarget(target: .tour))
        case .checkAuth:
            return Observable.of(self.oauth2Service.checkLoginStatus())
                .debug()
                .map{ (auth) -> Mutation in
                    if (auth) {
                        return Mutation.setNaviTarget(target: .main)
                    } else {
                        return Mutation.setNaviTarget(target: .login)
                    }
            }
        case .navigateTo:
            return state
                .take(1)
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
                .observeOn(MainScheduler.asyncInstance)
                .flatMap{ (state) -> Observable<Mutation> in
                    switch state.nav {
                    case .login:
                        AppDelegate.shared.rootViewController.showLoginScreen()
                    case .main:
                        AppDelegate.shared.rootViewController.switchToMainScreen()
                    case .tour:
                        AppDelegate.shared.rootViewController.switchToTour()
                    }
                    return Observable.empty()
            }
        case .tick:
            return Observable.of(Mutation.setTick)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .setTick:
            var newState = state
            newState.countDown -= 1
            return newState
        case .setNaviTarget(let target):
            var newState = state
            newState.nav = target
            return newState
        case .setTour:
            var newState = state
            newState.tourPresented = true
            return newState
        }
    }
    
    func transform(action: Observable<Action>) -> Observable<Action> {
        return action.debug("action") // Use RxSwift's debug() operator
    }
}
