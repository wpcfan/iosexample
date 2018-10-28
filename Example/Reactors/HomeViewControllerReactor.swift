//
//  HomeViewReactor.swift
//  Example
//
//  Created by 王芃 on 2018/10/16.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import RxSwift
import ReactorKit
import Moya_ObjectMapper

class HomeViewReactor: Reactor {
    enum Action {
        case loadBanners
        case loadChannels
        case loadScenes
    }
    
    enum Mutation {
        case loadBannersSuccess(_ banners: [Banner])
        case loadChannelsSuccess(_ channels: [Banner])
        case loadScenesSuccess(_ scenes: [Scene])
    }
    
    struct State {
        var banners: [Banner] = []
        var channels: [Banner] = []
        var scenes: [Scene] = []
        var loadingBanners: Bool = false
        var loadingChannels: Bool = false
        var loadingScenes: Bool = false
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .loadBanners:
            return HomeProvider
                .request(.banners)
                .mapArray(Banner.self)
                .map { Mutation.loadBannersSuccess($0) }
                .asObservable()
        case .loadChannels:
            return HomeProvider
                .request(.channels)
                .mapArray(Banner.self)
                .map { Mutation.loadChannelsSuccess($0) }
                .asObservable()
        case .loadScenes:
            return HomeProvider
                .request(.scenes)
                .mapArray(Scene.self)
                .map { Mutation.loadScenesSuccess($0) }
                .asObservable()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .loadBannersSuccess(let banners):
            var newState = state
            newState.banners = banners
            return newState
        case .loadChannelsSuccess(let channels):
            var newState = state
            newState.channels = channels
            return newState
        case .loadScenesSuccess(let scenes):
            var newState = state
            newState.scenes = scenes
            return newState
        }
    }
}
