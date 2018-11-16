//
//  Reactive+Reusable.swift
//  Example
//
//  Created by 王芃 on 2018/11/15.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

private var prepareForReuseBag: Int8 = 0

@objc public protocol ReusableView : class {
    func prepareForReuse()
}

extension UITableViewCell: ReusableView {}
extension UITableViewHeaderFooterView: ReusableView {}
extension UICollectionReusableView: ReusableView {}

extension Reactive where Base: ReusableView {
    var prepareForReuse: Observable<Void> {
        return Observable.of(sentMessage(#selector(Base.prepareForReuse)).map { _ in }, deallocated).merge()
    }
    
    var reuseBag: DisposeBag {
        MainScheduler.ensureExecutingOnScheduler()
        
        if let bag = objc_getAssociatedObject(base, &prepareForReuseBag) as? DisposeBag {
            return bag
        }
        
        let bag = DisposeBag()
        objc_setAssociatedObject(base, &prepareForReuseBag, bag, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        
        _ = sentMessage(#selector(Base.prepareForReuse))
            .subscribe(onNext: { [weak base] _ in
                let newBag = DisposeBag()
                objc_setAssociatedObject(base!, &prepareForReuseBag, newBag, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            })
        
        return bag
    }
}
