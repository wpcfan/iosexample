//
//  UIScrollView+.swift
//  Example
//
//  Created by 王芃 on 2018/11/14.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import UIKit

enum Edge {
    
    case left, right, top, bottom
}

extension UIScrollView {
    
    func near(edge: Edge, clearance: CGFloat = 0) -> Bool {
        switch edge {
        case .left:
            return contentOffset.x + contentInset.left - clearance <= 0
        case .right:
            return (contentOffset.x + bounds.width - contentInset.right + clearance) >= contentSize.width
        case .top:
            return contentOffset.y + contentInset.top - clearance <= 0
        case .bottom:
            return (contentOffset.y + bounds.height + clearance) >= contentSize.height
        }
    }
}
