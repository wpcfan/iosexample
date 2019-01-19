//
//  Date+.swift
//  Example
//
//  Created by 王芃 on 2019/1/19.
//  Copyright © 2019 twigcodes. All rights reserved.
//

extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
