//
//  BannerViewReactor.swift
//  Example
//
//  Created by 王芃 on 2018/10/20.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import RxSwift
import ReactorKit
import Moya_ObjectMapper
import Moya
import URLNavigator

class BannerViewReactor: Reactor {
    
    enum Action {
        case load
    }
    
    enum Mutation {
        case loadSuccess(_ banners: [Banner])
        case loadFail(_ error: APIError)
        case selected(_ idx: Int)
    }
    
    struct State {
        var banners: [Banner]
        var selectedIndex: Int?
        var error: APIError?
    }
    
    let initialState: State = State(banners: [], selectedIndex: nil, error: nil)
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            return
                HomeProvider.request(.banners)
                    .mapArray(Banner.self)
                    .map { .loadSuccess($0) }
                    .asObservable()
                    .catchError({ err -> Observable<BannerViewReactor.Mutation> in
                        if let error = err as? MoyaError, let body = try! error.response?.mapObject(APIError.self) {
                            return Observable.of(.loadFail(body))
                        }
                        return Observable.of(.loadFail(APIError(title: "Uncatched Exception", status: -1, detail: "Unkown Reason", type: "UnkownHttpError", stacktrace: [])))
                    })
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .loadSuccess(banners):
            var newState = state
            newState.banners = banners
            return newState
        case let .loadFail(error):
            var newState = state
            newState.error = error
            return newState
        case let .selected(idx):
            var newState = state
            newState.selectedIndex = idx
            return newState
        }
    }
}
