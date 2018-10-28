//
//  Reactive+UIScrollView.swift
//  Example
//
//  Created by 王芃 on 2018/10/28.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PINRemoteImage

public extension Reactive where Base: UIScrollView {
    func backgroundImage<T>() -> Binder<T> {
        return Binder(base) { scrollview, value in
            let imageManager = PINRemoteImageManager.shared()
            imageManager.downloadImage(with: URL(string: value as! String)!) { result in
                scrollview.backgroundColor = UIColor(patternImage: result.image!.appliedBlur(withRadius: 0.2)!)
            }
        }
    }
}
