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

class HomeViewControllerReactor: Reactor {
    enum Action {
        case changeBackground
        case bannerTap
    }
    
    struct State {
        var loggedIn: Bool = false
        var logging: Bool = false
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Action> {
        switch action {
        default:
            return Observable.of(action)
        }
    }
    
    func reduce(state: State, mutation: Action) -> State {
        switch mutation {
            
        default:
            return state
        }
    }
}
