//
//  BaseView.swift
//  Example
//
//  Created by 王芃 on 2018/10/19.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Layout

class BaseView: UIView {
    // MARK: Properties
    var disposeBag = DisposeBag()
}

extension BaseView: LayoutLoading {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Ensure layout is updated after screen rotation, etc
        self.layoutNode?.view.frame = self.bounds
        // Update frame to match layout
        self.frame.size = self.intrinsicContentSize
    }
    
    public override var intrinsicContentSize: CGSize {
        return layoutNode?.frame.size ?? .zero
    }
}

extension Reactive where Base: UIView {
    var setNeedsLayout: Binder<Void> {
        return Binder(self.base) { view, _ in
            view.setNeedsLayout()
        }
    }
}
