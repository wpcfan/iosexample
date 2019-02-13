//
//  Array+.swift
//  Example
//
//  Created by 王芃 on 2019/2/13.
//  Copyright © 2019 twigcodes. All rights reserved.
//

extension Array {
    func keyBy<Key: Hashable>(_ keyFor: (Element) -> Key) -> [Key: Element] {
        var ret = [Key: Element]()
        for item in self{
            ret[keyFor(item)] = item
        }
        return ret
    }
}
