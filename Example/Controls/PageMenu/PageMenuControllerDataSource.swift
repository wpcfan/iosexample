//
//  PageMenuControllerDataSource.swift
//  Example
//
//  Created by 王芃 on 2018/11/14.
//  Copyright © 2018 twigcodes. All rights reserved.
//

@objc public protocol PageMenuControllerDataSource: class {
    
    /// The view controllers to display in the page menu view controller.
    func viewControllers(forPageMenuController pageMenuController: PageMenuController) -> [UIViewController]
    
    /// The view controllers to display in the page menu view controller.
    func menuTitles(forPageMenuController pageMenuController: PageMenuController) -> [String]
    
    /// The default page index to display in the page menu view controller.
    func defaultPageIndex(forPageMenuController pageMenuController: PageMenuController) -> Int
}
