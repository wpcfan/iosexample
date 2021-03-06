//
//  BannerViewReactor.swift
//  Example
//
//  Created by 王芃 on 2018/10/20.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import RxSwift
import ReactorKit

class ChannelViewReactor: Reactor {
    
    enum Action {
        case load
    }
    
    enum Mutation {
        case loadSuccess(_ channels: [Banner])
        case loadFail(_ error: APIError)
    }
    
    struct State {
        var channels: [Banner]
        var error: APIError?
    }
    
    let initialState: State = State(channels: [], error: nil)
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            return Observable.of(.loadSuccess([]))
//                HomeProvider.request(.channels)
//                    .mapArray(Banner.self)
//                    .map { .loadSuccess($0) }
//                    .asObservable()
//                    .catchError({ err -> Observable<ChannelViewReactor.Mutation> in
//                        if let error = err as? MoyaError, let body = try! error.response?.mapObject(APIError.self) {
//                            return Observable.of(.loadFail(body))
//                        }
//                        return Observable.of(.loadFail(APIError(title: "Uncatched Exception", status: -1, detail: "Unkown Reason", type: "UnkownHttpError", stacktrace: [])))
//                    })
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case let .loadSuccess(channels):
            var newState = state
            newState.channels = channels
            return newState
        case let .loadFail(error):
            var newState = state
            newState.error = error
            return newState
        }
    }
}
