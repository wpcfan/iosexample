//
//  AnimationExtensions.swift
//  Example
//
//  Created by 王芃 on 2018/10/30.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import UIKit

extension CGPath {
    func forEach( body: @escaping @convention(block) (CGPathElement) -> Void) {
        typealias Body = @convention(block) (CGPathElement) -> Void
        func callback(info: UnsafeMutableRawPointer?, element: UnsafePointer<CGPathElement>) {
            let body = unsafeBitCast(info, to: Body.self)
            body(element.pointee)
        }
        let unsafeBody = unsafeBitCast(body, to: UnsafeMutableRawPointer.self)
        apply(info: unsafeBody, function: callback)
    }
}

/*
 Finds the first point in a path. Uses the CGPath extension created above.
 */
extension UIBezierPath {
    func firstPoint() -> CGPoint? {
        var firstPoint: CGPoint? = nil
        
        cgPath.forEach { element in
            // Just want the first one, but we have to look at everything.
            guard firstPoint == nil else { return }
            assert(element.type == .moveToPoint, "Expected the first point to be a move")
            firstPoint = element.points.pointee
        }
        return firstPoint
    }
}
