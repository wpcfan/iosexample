//
//  Typing.swift
//  Example
//
//  Created by 王芃 on 2019/1/18.
//  Copyright © 2019 twigcodes. All rights reserved.
//

struct Partial<Wrapped> {
    
    private var values: [PartialKeyPath<Wrapped>: Any] = [:]
    
    subscript<ValueType>(key: KeyPath<Wrapped, ValueType>) -> ValueType? {
        get {
            return values[key] as? ValueType
        }
        set {
            values[key] = newValue
        }
    }
    
}
