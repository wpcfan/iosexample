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

class BaseView: UIView {
    // MARK: Properties
    var disposeBag = DisposeBag()
}

extension Reactive where Base: UIView {
    var setNeedsLayout: Binder<Void> {
        return Binder(self.base) { view, _ in
            view.setNeedsLayout()
        }
    }
}
