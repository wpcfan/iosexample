//
//  TourViewControllerReactor.swift
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

class TourViewControllerReactor: Reactor {
    private let storage = container.resolve(Storage<Filename, AppData>.self)!
    private let oauth2Service = container.resolve(OAuth2Service.self)!
    
    enum NavTarget {
        case login
        case main
    }
    
    enum Action {
        case setNaviTarget(target: NavTarget)
        case navigateTo
        case setFirstLaunch
        case checkAuth
    }
    
    struct State {
        var nav: NavTarget
    }
    
    let initialState: State = State(nav: .login)
    
    func mutate(action: Action) -> Observable<Action> {
        switch action {
        case .setFirstLaunch:
            return self.storage
                .rx_set(value: AppData(tourGuidePresented: true), forKey: "data")
                .flatMap { (val) -> Observable<Action> in
                    return Observable.empty()
                }
                .catchError({ (error) -> Observable<Action> in
                    log.error("storage saving error: " + error.localizedDescription)
                    return Observable.empty()
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
                    }
                    return Observable.empty()
            }
        default:
            return Observable.of(action)
        }
    }
    
    func reduce(state: State, mutation: Action) -> State {
        switch mutation {
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

