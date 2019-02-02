//
//  TourViewControllerReactor.swift
//  Example
//
//  Created by 王芃 on 2018/10/27.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import RxSwift
import ReactorKit
import URLNavigator
import Disk
import ObjectMapper

class TourViewControllerReactor: Reactor {
    
    enum NavTarget {
        case login
        case main
    }
    
    enum Action {
        case checkAuth
        case completeTour
    }
    
    enum Mutation {
        case setNavTarget(target: NavTarget)
        case setTour(completed: Bool)
    }
    
    struct State {
        var nav: NavTarget
        var tourGuidePresented: Bool
    }
    
    let initialState: State = State(nav: .login, tourGuidePresented: false)
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .completeTour:
            do{
                try Disk.save(Mapper<AppData>().map(JSON: ["tourGuidePresented": true]), to: .documents, as: Constants.APP_DATA_PATH)
                return Observable.of(.setTour(completed: true))
            }
            catch {
                print("storage saving error: \(String(describing: error))")
                return Observable.of(.setTour(completed: false))
            }
        case .checkAuth:
            let data = try? Disk.retrieve(Constants.APP_DATA_PATH, from: .documents, as: AppData.self)
            if (data?.token != nil && data?.user != nil) {
                return Observable.of(.setNavTarget(target: .main))
            } else {
                return Observable.of(.setNavTarget(target: .login))
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .setNavTarget(let target):
            var newState = state
            newState.nav = target
            return newState
        case .setTour(let completed):
            var newState = state
            newState.tourGuidePresented = completed
            return newState
        }
    }
}

