//
//  UIView+Corners.swift
//  Example
//
//  Created by 王芃 on 2019/3/1.
//  Copyright © 2019 twigcodes. All rights reserved.
//

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
