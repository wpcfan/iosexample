//
//  SceneTableViewReactor.swift
//  Example
//
//  Created by 王芃 on 2019/2/25.
//  Copyright © 2019 twigcodes. All rights reserved.
//
import RxSwift
import ReactorKit
import Dollar

class SceneTableViewReactor: Reactor {
    let scService = container.resolve(JdSmartCloudService.self)!
    let scenesService = container.resolve(SceneListService.self)!
    
    enum Action {
        case load
        case startReorder(_ sourceIndex: Int, _ targetIndex: Int)
    }
    
    enum Mutation {
        case loadSuccess(_ scenes: [HouseScene])
        case loadFail(_ message: String)
        case loading(_ status: Bool)
        case reorder(_ sourceIndex: Int, _ targetIndex: Int)
    }
    
    struct State {
        var scenes: [HouseScene] = []
        var loading: Bool = false
        var errorMessage: String = ""
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .load:
            return self.scenesService.request()
                .flatMapFirst({ (houseScenes) -> Observable<[HouseScene]> in
                    self.scService.getScenes(page: 1, pageSize: 100)
                        .map({ (col) -> [HouseScene] in
                            houseScenes.map{ houseScene in
                                let newHouseScene = houseScene
                                newHouseScene.scene = Dollar.find(col!.scripts!) {
                                    $0.script?.id == houseScene.scriptId
                                }
                                if (newHouseScene.scene != nil) {
                                    return newHouseScene
                                }
                                switch(newHouseScene.innerCode) {
                                case 1:
                                    newHouseScene.scene = Scene(JSON: ["name": "回家"])
                                    break
                                case 2:
                                    newHouseScene.scene = Scene(JSON: ["name": "离家"])
                                    break
                                default:
                                    break
                                }
                                return newHouseScene
                            }
                            .filter({ (houseScene) -> Bool in
                                houseScene.scene?.displayName != nil
                            })
                        })
                })
                .map { scenes -> Mutation in .loadSuccess(scenes) }
                .catchError{ error -> Observable<Mutation>  in
                    Observable.of(.loadFail(convertErrorToString(error: error)))
            }
        case .startReorder(let sourceIndex, let targetIndex):
            return .of(.reorder(sourceIndex, targetIndex))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .loadSuccess(let scenes):
            var newState = state
            newState.scenes = scenes
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
        case let .reorder(sourceIndex, targetIndex):
            var newState = state
            var newScenes = state.scenes
            let item = state.scenes[sourceIndex]
            newScenes.remove(at: sourceIndex)
            newScenes.insert(item, at: targetIndex)
            newState.scenes = newScenes
            newState.errorMessage = ""
            return newState
        }
    }
}
