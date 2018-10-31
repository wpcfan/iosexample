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
    
    enum Mutation {
        case tabSelected(idx: Int)
    }
    
    struct State {
        var selectedTopTab: Int
    }
    
    let initialState: State = State(selectedTopTab: 0)
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        default:
            return Observable.empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
            
        default:
            return state
        }
    }
}
