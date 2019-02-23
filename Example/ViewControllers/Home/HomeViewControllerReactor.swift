//
//  HomeViewReactor.swift
//  Example
//
//  Created by 王芃 on 2018/10/16.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import RxSwift
import ReactorKit
import ObjectMapper

class HomeViewControllerReactor: Reactor {
    let homeService = container.resolve(HomeService.self)!
    let pushRegIdService = container.resolve(PushRegIdService.self)!
    let scService = container.resolve(JdSmartCloudService.self)!
    let loaded = PublishSubject<Void>()
    private let INDOOR_ENV_PROD_ID = "J8X7KB"
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
        case loadIndoorAirSuccess(_ result: IndoorAir?)
        case loadIndoorAirFail(_ message: String)
    }
    
    struct State {
        var homeInfo: HomeInfo? = nil
        var loading: Bool = false
        var errorMessage: String = ""
        var regIdReported: Bool = false
        var indoorEnvSnapShot: IndoorAir? = nil
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load, .refresh:
            let homeStream = self.homeService.handleHomeInfo(cached: false).share()
            let load$: Observable<Mutation> = homeStream
                .debug()
                .map { home -> Mutation in .loadSuccess(home) }
                .catchError{ error -> Observable<Mutation>  in
                    Observable.of(.loadFail(convertErrorToString(error: error)))
                }
            let indoorAirDevice$ = homeStream
                .map({ $0.devices?.filter({ (device: Device) -> Bool in
                    device.productId == self.INDOOR_ENV_PROD_ID
                }) ?? []
                })
                .filter({ (devices) -> Bool in
                    devices.count > 0
                })
                .map { (devices: [Device]) in String(devices[0].feedId!) }
            let loadIndoorAir$: Observable<Mutation> = indoorAirDevice$
                .flatMap { id in
                    self.scService.deviceSnapshotV2(feedId: id)
                        .map { (result) -> Mutation in
                            .loadIndoorAirSuccess(Mapper<IndoorAir>().map(JSON: result!.toPlainDict()))
                        }
                        .catchError{ error -> Observable<Mutation>  in
                            Observable.of(.loadIndoorAirFail(convertErrorToString(error: error)))
                    }
                }
                .debug()
            return Observable.merge([load$, loadIndoorAir$])
        case .reportPushRegId:
            return pushRegIdService.request()
                .map { _ -> Mutation in .setRegId(true) }
                .catchError{ error -> Observable<Mutation>  in
                    Observable.of(.setRegId(false))
                }
                .debug()
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
            newState.indoorEnvSnapShot = nil
            return newState
        case .setRegId(let status):
            var newState = state
            newState.regIdReported = status
            return newState
        case .loadIndoorAirSuccess(let snapshot):
            var newState = state
            newState.errorMessage = ""
            newState.indoorEnvSnapShot = snapshot
            return newState
        case .loadIndoorAirFail(let errorMessage):
            var newState = state
            newState.indoorEnvSnapShot = nil
            newState.errorMessage = errorMessage
            return newState
        }
    }
}
