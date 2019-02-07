//
//  HomeDeviceCollectionCellReactor.swift
//  Example
//
//  Created by 王芃 on 2019/2/3.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import RxSwift
import ReactorKit
import Disk

class HomeDeviceCollectionCellReactor: Reactor {
    let homeService = container.resolve(HomeService.self)!
    enum Action {
        case load
    }
    
    enum Mutation {
        case loadSuccess(_ devices: [Device])
        case loading(_ status: Bool)
    }
    
    struct State {
        var devices: [Device]
        var loading: Bool
    }
    
    let initialState: State = State(devices: [], loading: false)
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            return self.homeService.request()
                .map { (home: HomeInfo) -> Mutation in .loadSuccess(home.devices ?? []) }
                .catchError{ error -> Observable<Mutation>  in
                    Observable.of(.loadSuccess([]))
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .loadSuccess(let devices):
            var newState = state
            newState.devices = devices
            newState.loading = false
            return newState
        case .loading(let status):
            var newState = state
            newState.loading = status
            return newState
        }
    }
}
