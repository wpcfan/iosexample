//
//  BaseItemCell.swift
//  Example
//
//  Created by 王芃 on 2018/10/19.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class BaseTableCell: UITableViewCell {
    // MARK: Properties
    var disposeBag = DisposeBag()
    
    // MARK: Initializing
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        // Override point
    }
}

extension Reactive where Base: BaseTableCell {
    var tap: ControlEvent<Void> {
        let source = self.base.rx.tapGesture().when(.recognized).map { _ in }
        return ControlEvent(events: source)
    }
}
