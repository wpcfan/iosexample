//
//  Reactive+Layout.swift
//  Example
//
//  Created by 王芃 on 2018/10/16.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import RxSwift
import RxCocoa
import Layout

extension Reactive where Base: LayoutNode {
    
    func state<T>(_ key: String) -> Binder<T> {
        return Binder(base) { node, value in
            node.setState([key: value], animated: true)
        }
    }
}
