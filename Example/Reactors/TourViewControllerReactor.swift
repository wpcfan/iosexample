//
//  TourViewControllerReactor.swift
//  Example
//
//  Created by 王芃 on 2018/10/27.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import RxSwift
import ReactorKit
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
        case checkAuth
        case completeTour
    }
    
    enum Mutation {
        case setNav(target: NavTarget)
        case setTour(completed: Bool)
    }
    
    struct State {
        var nav: NavTarget
        var tourGuidePresented: Bool
    }
    
    let initialState: State = State(nav: .login, tourGuidePresented: false)
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .completeTour:
            return self.storage
                .rx_set(value: AppData(tourGuidePresented: true), forKey: "data")
                .flatMap { (val) -> Observable<Mutation> in
                    return Observable.of(.setTour(completed: true))
                }
                .catchError({ (error) -> Observable<Mutation> in
                    print("storage saving error: " + error.localizedDescription)
                    return Observable.of(.setTour(completed: false))
                })
        case .checkAuth:
            return Observable.of(self.oauth2Service.checkLoginStatus())
                .flatMap({ (auth) -> Observable<Mutation> in
                    if (auth) {
                        return Observable.of(.setNav(target: .main))
                    } else {
                        return Observable.of(.setNav(target: .login))
                    }
                })
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .setNav(let target):
            var newState = state
            newState.nav = target
            return newState
        case .setTour(let completed):
            var newState = state
            newState.tourGuidePresented = completed
            return newState
        }
    }
}

