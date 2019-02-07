//
//  HouseTableViewControllerReactor.swift
//  Example
//
//  Created by 王芃 on 2019/2/1.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import RxSwift
import ReactorKit
import Disk

class HouseTableViewControllerReactor: Reactor {
    let houseService = container.resolve(MyHouseService.self)!
    enum Action {
        case load
        case selectHouse(house: House)
    }
    
    enum Mutation {
        case loadSuccess(_ houses: [House])
        case loadFail(_ message: String)
        case loading(_ status: Bool)
        case selected(_ houseId: String)
    }
    
    struct State {
        var houses: [House]
        var loading: Bool
        var errorMessage: String
        var selectedId: String
    }
    
    let initialState: State = State(houses: [], loading: false, errorMessage: "", selectedId: "")
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            let data = try? Disk.retrieve(Constants.APP_DATA_PATH, from: .documents, as: AppData.self)
            self.houseService.userId = data?.user?.id
            return self.houseService.request()
                .map { houses -> Mutation in .loadSuccess(houses) }
                .catchError{ error -> Observable<Mutation>  in
                    Observable.of(.loadFail(convertErrorToString(error: error)))
            }
        case let .selectHouse(house):
            CURRENT_HOUSE.onNext(house)
            return Observable.of(Mutation.selected(house.id ?? ""))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .loadSuccess(let houses):
            var newState = state
            newState.houses = houses
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
        case .selected(let houseId):
            var newState = state
            newState.selectedId = houseId
            newState.errorMessage = ""
            return newState
        }
    }
}