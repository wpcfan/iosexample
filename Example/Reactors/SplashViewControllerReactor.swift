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
        case tick(countDown: Int)
        case setNaviTarget(target: NavTarget)
        case navigateTo
        case checkFirstLaunch
        case checkAuth
    }
    
    struct State {
        var countDown: Int
        var nav: NavTarget
    }
    
    let initialState: State = State(countDown: 5, nav: .login)
    
    func mutate(action: Action) -> Observable<Action> {
        switch action {
        case .checkFirstLaunch:
            return self.storage
                .rx_retrieve(forKey: "data")
                .flatMap { (val) -> Observable<Action> in
                    let result = val as? AppData
                    if (result?.tourGuidePresented ?? false) {
                        return Observable.of(Mutation.checkAuth)
                    } else {
                        return Observable.of(Mutation.setNaviTarget(target: .tour))
                    }
                }
                .catchError({ (error) -> Observable<Action> in
                    Observable.of(Mutation.setNaviTarget(target: .tour))
                })
                .take(1)
        case .checkAuth:
            return Observable.of(self.oauth2Service.checkLoginStatus())
                .flatMap({ (auth) -> Observable<Action> in
                    if (auth) {
                        return Observable.of(Mutation.setNaviTarget(target: .main))
                    } else {
                        return Observable.of(Mutation.setNaviTarget(target: .login))
                    }
                })
        case .navigateTo:
            return state
                .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
                .observeOn(MainScheduler.asyncInstance)
                .flatMap{ (state) -> Observable<Action> in
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
        default:
            return Observable.of(action)
        }
    }
    
    func reduce(state: State, mutation: Action) -> State {
        switch mutation {
        case .tick(let countDown):
            var newState = state
            newState.countDown = countDown
            return newState
        case .setNaviTarget(let target):
            var newState = state
            newState.nav = target
            return newState
        default:
            return state
        }
    }
    
    func transform(action: Observable<Action>) -> Observable<Action> {
        return action.debug("action") // Use RxSwift's debug() operator
    }
}
