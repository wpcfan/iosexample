//
//  UIImage+Layout.swift
//  Example
//
//  Created by 王芃 on 2018/10/14.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import UIKit
import Layout
import AlamofireImage

extension UIImageView {
    
    @objc open override class var expressionTypes: [String: RuntimeType] {
        var types = super.expressionTypes
        types["imgUrl"] = RuntimeType(String.self)
        return types
    }
    
    @objc open override func setValue(_ value: Any, forExpression name: String) throws {
        switch name {
        case "imgUrl":
            self.af_setImage(withURL: URL(string: (value as? String)!)!)
        default:
            try super.setValue(value, forExpression: name)
        }
    }
}
