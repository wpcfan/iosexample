//
//  WeatherViewReactor.swift
//  Example
//
//  Created by 王芃 on 2019/2/15.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import RxSwift
import ReactorKit

class WeatherViewReactor: Reactor {
    let weatherService = container.resolve(WeatherService.self)!
    enum Action {
        case load
    }
    
    enum Mutation {
        case loadSuccess(_ weather: Weather)
        case loadFail(_ message: String)
        case loading(_ status: Bool)
    }
    
    struct State {
        var weather: Weather? = nil
        var loading: Bool = false
        var errorMessage: String = ""
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            return self.weatherService.request(cacheResponse: true, returnCachedResponse: true, invokeRequest: true)
                .map { weather -> Mutation in .loadSuccess(weather) }
                .catchError{ error -> Observable<Mutation>  in
                    Observable.of(.loadFail(convertErrorToString(error: error)))
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .loadSuccess(let weather):
            var newState = state
            newState.weather = weather
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
