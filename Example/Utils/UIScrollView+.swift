//
//  UIScrollView+.swift
//  Example
//
//  Created by 王芃 on 2018/10/26.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import UIKit
import PINRemoteImage

extension UIScrollView {
    
    public func setBlurBackgroundImage(url: String) {
        let imageManager = PINRemoteImageManager.shared()
        imageManager.downloadImage(with: URL(string: url)!) { result in
            self.backgroundColor = UIColor(patternImage: result.image!.blur())
        }
    }
    
    public func setBlurBackgroundImage(with: UIImage) {
        self.backgroundColor = UIColor(patternImage: with.blur())
    }
}
