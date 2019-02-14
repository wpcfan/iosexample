//
//  Dictionary+.swift
//  Example
//
//  Created by 王芃 on 2019/2/14.
//  Copyright © 2019 twigcodes. All rights reserved.
//

extension Dictionary {
    
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
    
    func printJson() {
        print(json)
    }
    
    func valuesMapped<T>(_ transform: (Value) -> T) -> [Key: T] {
        var newDict = [Key: T]()
        for (key, value) in self {
            newDict[key] = transform(value)
        }
        return newDict
    }
}
