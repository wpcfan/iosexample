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

class ChannelViewReactor: Reactor {
    
    enum Action {
        case load
        case loadSuccess(_ channels: [Banner])
        case loadFail(_ error: APIError)
    }
    
    struct State {
        var channels: [Banner]
        var error: APIError?
    }
    
    let initialState: State = State(channels: [], error: nil)
    
    func mutate(action: Action) -> Observable<Action> {
        switch action {
        case .load:
            return
                HomeProvider.request(.channels)
                    .mapArray(Banner.self)
                    .map { Action.loadSuccess($0) }
                    .asObservable()
                    .catchError({ err -> Observable<ChannelViewReactor.Action> in
                        if let error = err as? MoyaError, let body = try! error.response?.mapObject(APIError.self) {
                            return Observable.of(Mutation.loadFail(body))
                        }
                        return Observable.of(Mutation.loadFail(APIError(title: "Uncatched Exception", status: -1, detail: "Unkown Reason", type: "UnkownHttpError", stacktrace: [])))
                    })
        default:
            return Observable.of(action)
        }
    }
    
    func reduce(state: State, mutation: Action) -> State {
        switch mutation {
        case let .loadSuccess(channels):
            var newState = state
            newState.channels = channels
            return newState
        case let .loadFail(error):
            var newState = state
            newState.error = error
            return newState
        default:
            return state
        }
    }
}
