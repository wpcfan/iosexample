//
//  Reactive+FSPagerView.swift
//  Example
//
//  Created by 王芃 on 2018/10/18.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import RxSwift
import RxCocoa
import RxGesture
import FSPagerView

extension Reactive where Base: FSPagerViewCell {
    var imageTap: ControlEvent<UITapGestureRecognizer> {
        let source = base.imageView!.rx.tapGesture().when(.recognized)
        return ControlEvent(events: source)
    }
}
