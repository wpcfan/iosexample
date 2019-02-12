//
//  HomeViewReactor.swift
//  Example
//
//  Created by 王芃 on 2018/10/16.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import RxSwift
import ReactorKit
import Disk

class HomeViewControllerReactor: Reactor {
    let homeService = container.resolve(HomeService.self)!
    let pushRegIdService = container.resolve(PushRegIdService.self)!
    enum Action {
        case load
        case refresh
        case reportPushRegId
    }
    
    enum Mutation {
        case loadSuccess(_ homeInfo: HomeInfo)
        case loadFail(_ message: String)
        case loading(_ status: Bool)
        case setRegId(_ statue: Bool)
    }
    
    struct State {
        var homeInfo: HomeInfo?
        var loading: Bool
        var errorMessage: String
        var regIdReported: Bool
    }
    
    let initialState: State = State(homeInfo: nil, loading: false, errorMessage: "", regIdReported: false)
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load, .refresh:
            return self.homeService.handleHomeInfo(cached: false)
                .debug()
                .map { home -> Mutation in .loadSuccess(home) }
                .catchError{ error -> Observable<Mutation>  in
                    Observable.of(.loadFail(convertErrorToString(error: error)))
                }
        case .reportPushRegId:
            return pushRegIdService.request()
                .debug()
                .map { _ -> Mutation in .setRegId(true) }
                .catchError{ error -> Observable<Mutation>  in
                    Observable.of(.setRegId(false))
                }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .loadSuccess(let home):
            var newState = state
            newState.homeInfo = home
            newState.loading = false
            newState.errorMessage = ""
            return newState
        case .loadFail(let errorMessage):
            var newState = state
            newState.loading = false
            newState.errorMessage = errorMessage
            return newState
        case .loading(let status):
            var newState = state
            newState.loading = status
            newState.errorMessage = ""
            return newState
        case .setRegId(let status):
            var newState = state
            newState.regIdReported = status
            return newState
        }
    }
}
