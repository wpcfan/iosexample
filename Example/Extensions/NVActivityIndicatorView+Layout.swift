//
//  NVActivityIndicatorView+Layout.swift
//  Example
//
//  Created by 王芃 on 2019/2/23.
//  Copyright © 2019 twigcodes. All rights reserved.
//
import NVActivityIndicatorView
import Layout

extension NVActivityIndicatorView {
    public override class var parameterTypes: [String: RuntimeType] {
        return [
            "type": RuntimeType(NVActivityIndicatorType.self),
            "color": RuntimeType(UIColor.self),
            "padding": RuntimeType(CGFloat.self),
        ]
    }
    
    public override class func create(with node: LayoutNode) throws -> NVActivityIndicatorView {
        if let type = try node.value(forExpression: "type") as? NVActivityIndicatorType,
            let color = try node.value(forExpression: "color") as? UIColor,
            let padding = try node.value(forExpression: "padding") as? CGFloat {
            return self.init(frame: .zero, type: type, color: color, padding: padding)
        }
        return self.init(frame: .zero)
    }
}
