//
//  UITableView+.swift
//  Example
//
//  Created by 王芃 on 2019/2/9.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import Foundation

extension UITableView {
    func findReorderViewInView(view: UIView) -> UIView? {
        for subview in view.subviews {
            if subview.self.description.contains("Reorder") {
                return subview
            }
            return findReorderViewInView(view: subview)
        }
        return nil
    }

}
