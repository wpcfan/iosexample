//
//  UnderlineCursorView.swift
//  Example
//
//  Created by 王芃 on 2018/11/14.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import UIKit

class UnderlineCursorView: UIView, TabMenuItemCursor {
    
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
            parent.addSubview(self)
            self.snp.makeConstraints {
                $0.height.equalTo(options.menuCursor.height)
                $0.centerX.bottom.equalToSuperview()
            }
            self.currentBarViewWidthConstraint = self.widthAnchor.constraint(equalToConstant: 100)
            self.currentBarViewWidthConstraint?.isActive = true
        } else {
            parent.addSubview(self)
            self.snp.makeConstraints {
                $0.height.equalTo(options.menuCursor.height)
                $0.top.equalToSuperview().offset(options.menuItemSize.height - options.menuCursor.height)
            }
            self.currentBarViewWidthConstraint = self.widthAnchor.constraint(equalToConstant: 100)
            self.currentBarViewWidthConstraint?.isActive = true
            self.currentBarViewLeftConstraint = self.leftAnchor.constraint(equalTo: parent.leftAnchor)
            self.currentBarViewLeftConstraint?.isActive = true
        }
    }
    
    func updateWidth(width: CGFloat) {
        self.currentBarViewWidthConstraint?.constant = width
    }
    
    func updatePosition(x: CGFloat) {
        self.currentBarViewLeftConstraint?.constant = x
    }
}
