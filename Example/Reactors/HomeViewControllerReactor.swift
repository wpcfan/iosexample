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
    enum Action {
        case load
    }
    
    enum Mutation {
        case loadSuccess(_ homeInfo: HomeInfo)
        case loadFail(_ message: String)
        case loading(_ status: Bool)
    }
    
    struct State {
        var homeInfo: HomeInfo?
        var loading: Bool
        var errorMessage: String
    }
    
    let initialState: State = State(homeInfo: nil, loading: false, errorMessage: "")
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            return self.homeService.request()
                .do(onNext: { home in
                    CURRENT_HOUSE.onNext(home.house)
                    var data = try Disk.retrieve(Constants.APP_DATA_PATH, from: .documents, as: AppData.self)
                    data.houseId = home.house?.id
                    data.projectId = home.house?.projectId
                    try Disk.save(data, to: .documents, as: Constants.APP_DATA_PATH)
                })
                .map { home -> Mutation in .loadSuccess(home) }
                .catchError{ error -> Observable<Mutation>  in
                    Observable.of(.loadFail(convertErrorToString(error: error)))
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
        }
    }
}
