//
//  PageMenuNavigationDirection.swift
//  Example
//
//  Created by 王芃 on 2018/11/14.
//  Copyright © 2018 twigcodes. All rights reserved.
//

@objc public enum PageMenuNavigationDirection: Int {
    
    /// Forward direction. Can be right in a horizontal orientation or down in a vertical orientation.
    case forward
    
    /// Reverse direction. Can be left in a horizontal orientation or up in a vertical orientation.
    case reverse
}

extension EMPageViewControllerNavigationDirection {
    
    var toPageMenuNavigationDirection: PageMenuNavigationDirection {
        switch self {
        case .forward:
            return .forward
        default:
            return .reverse
        }
    }
}
