//
//  TabMenuItemCursor.swift
//  Example
//
//  Created by 王芃 on 2018/11/14.
//  Copyright © 2018 twigcodes. All rights reserved.
//

protocol TabMenuItemCursor: class {
    
    var isHidden: Bool { get set }
    
    func setup(parent: UIView, isInfinite: Bool, options: PageMenuOptions)
    
    func updateWidth(width: CGFloat)
    
    func updatePosition(x: CGFloat)
}
