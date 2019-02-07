//
//  HomeSceneCollectionCellReactor.swift
//  Example
//
//  Created by 王芃 on 2019/2/3.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import RxSwift
import ReactorKit
import Disk

class HomeSceneCollectionCellReactor: Reactor {
    let homeService = container.resolve(HomeService.self)!
    enum Action {
        case load
    }
    
    enum Mutation {
        case loadSuccess(_ scenes: [Scene])
        case loading(_ status: Bool)
    }
    
    struct State {
        var scenes: [Scene]
        var loading: Bool
    }
    
    let initialState: State = State(scenes: [], loading: false)
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            return Observable.of(.loadSuccess([]))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .loadSuccess(let scenes):
            var newState = state
            newState.scenes = scenes
            newState.loading = false
            return newState
        case .loading(let status):
            var newState = state
            newState.loading = status
            return newState
        }
    }
}
