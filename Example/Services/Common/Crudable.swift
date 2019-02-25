//
//  BaseHttpService.swift
//  Example
//
//  Created by 王芃 on 2019/1/18.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import RxSwift
import ObjectMapper

protocol Crudable {
    associatedtype Entity: Mappable
    func getAll() -> Observable<[Entity]>
    func getBy(_ id: String) -> Observable<Entity>
    func add(_ entity: Entity) -> Observable<Entity>
    func update(_ id: String, _ changes: Entity) -> Observable<Entity>
    func delete(_ id: String) -> Observable<String>
}
