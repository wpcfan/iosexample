//
//  RoundRectCursorView.swift
//  Example
//
//  Created by 王芃 on 2018/11/14.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import UIKit

class RoundRectCursorView: UIView, TabMenuItemCursor {
    
    fileprivate var padding: CGFloat = 6
    
    fileprivate var currentBarViewWidthConstraint: NSLayoutConstraint?
    
    fileprivate var currentBarViewLeftConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(parent: UIView, isInfinite: Bool, options: PageMenuOptions) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if isInfinite {
            self.layer.zPosition = -1
            parent.insertSubview(self, at: 0)
            self.heightAnchor.constraint(equalToConstant: options.menuCursor.height).isActive = true
            self.centerXAnchor.constraint(equalTo: parent.centerXAnchor).isActive = true
            self.centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
            self.currentBarViewWidthConstraint = self.widthAnchor.constraint(equalToConstant: 100)
            self.currentBarViewWidthConstraint?.isActive = true
        } else {
            self.layer.zPosition = -1
            parent.insertSubview(self, at: 0)
            self.heightAnchor.constraint(equalToConstant: options.menuCursor.height).isActive = true
            self.centerYAnchor.constraint(equalTo: parent.centerYAnchor).isActive = true
            self.currentBarViewWidthConstraint = self.widthAnchor.constraint(equalToConstant: 100)
            self.currentBarViewWidthConstraint?.isActive = true
            self.currentBarViewLeftConstraint = self.leftAnchor.constraint(equalTo: parent.leftAnchor)
            self.currentBarViewLeftConstraint?.isActive = true
        }
    }
    
    func updateWidth(width: CGFloat) {
        self.currentBarViewWidthConstraint?.constant = width - self.padding
    }
    
    func updatePosition(x: CGFloat) {
        self.currentBarViewLeftConstraint?.constant = x + self.padding / 2
    }
}
