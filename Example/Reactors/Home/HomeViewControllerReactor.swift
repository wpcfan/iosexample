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
    let scService = container.resolve(JdSmartCloudService.self)!
    let loaded = PublishSubject<Void>()
    enum Action {
        case load
        case refresh
        case reportPushRegId
        case loadIndoorEnv(_ id: String)
    }
    
    enum Mutation {
        case loadSuccess(_ homeInfo: HomeInfo)
        case loadFail(_ message: String)
        case loading(_ status: Bool)
        case setRegId(_ statue: Bool)
        case loadIndoorEnvSuccess(_ result: SCV2Snapshot?)
        case loadIndoorEnvFail(_ message: String)
    }
    
    struct State {
        var homeInfo: HomeInfo? = nil
        var loading: Bool = false
        var errorMessage: String = ""
        var regIdReported: Bool = false
        var indoorEnvSnapShot: SCV2Snapshot? = nil
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load, .refresh:
            return self.homeService.handleHomeInfo(cached: false)
                .debug()
                .map { home -> Mutation in .loadSuccess(home) }
                .catchError{ error -> Observable<Mutation>  in
                    Observable.of(.loadFail(convertErrorToString(error: error)))
                }
                .do(onCompleted: { () in
                    self.loaded.onNext(())
                })
        case .reportPushRegId:
            return pushRegIdService.request()
                .debug()
                .map { _ -> Mutation in .setRegId(true) }
                .catchError{ error -> Observable<Mutation>  in
                    Observable.of(.setRegId(false))
                }
        case let .loadIndoorEnv(id):
            return scService.deviceSnapshotV2(id: id)
                .map { (result) -> Mutation in
                    .loadIndoorEnvSuccess(result)
                }
                .catchError{ error -> Observable<Mutation>  in
                    Observable.of(.loadIndoorEnvFail(convertErrorToString(error: error)))
                }
        }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        return Observable.merge(mutation, homeService.loading.map(Mutation.loading))
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
        case .loadIndoorEnvSuccess(let snapshot):
            var newState = state
            newState.errorMessage = ""
            newState.indoorEnvSnapShot = snapshot
            return newState
        case .loadIndoorEnvFail(let errorMessage):
            var newState = state
            newState.indoorEnvSnapShot = nil
            newState.errorMessage = errorMessage
            return newState
        }
    }
}
