//
//  PageMenuControllerDelegate.swift
//  Example
//
//  Created by 王芃 on 2018/11/14.
//  Copyright © 2018 twigcodes. All rights reserved.
//

@objc public protocol PageMenuControllerDelegate: class {
    
    /// The page view controller will begin scrolling to a new page.
    @objc optional func pageMenuController(_ pageMenuController: PageMenuController,
                                           willScrollToPageAtIndex index: Int,
                                           direction: PageMenuNavigationDirection)
    
    /// The page view controller scroll progress between pages.
    @objc optional func pageMenuController(_ pageMenuController: PageMenuController,
                                           scrollingProgress progress: CGFloat,
                                           direction: PageMenuNavigationDirection)
    
    /// The page view controller did complete scroll to a new page.
    @objc optional func pageMenuController(_ pageMenuController: PageMenuController,
                                           didScrollToPageAtIndex index: Int,
                                           direction: PageMenuNavigationDirection)
    
    /// The menu item of page view controller are selected.
    @objc optional func pageMenuController(_ pageMenuController: PageMenuController,
                                           didSelectMenuItem index: Int,
                                           direction: PageMenuNavigationDirection)
}
