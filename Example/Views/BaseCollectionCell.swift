//
//  BaseCollectionCell.swift
//  Example
//
//  Created by 王芃 on 2019/2/3.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

class BaseCollectionCell: UICollectionViewCell {
    // MARK: Properties
    var disposeBag: DisposeBag = DisposeBag()
    
    
    // MARK: Initializing
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        // Override point
    }
    
}

extension Reactive where Base: BaseCollectionCell {
    var tap: ControlEvent<Void> {
        let source = self.base.rx.tapGesture().when(.recognized).map { _ in }
        return ControlEvent(events: source)
    }
}
