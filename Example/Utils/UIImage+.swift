//
//  UIImage+.swift
//  Example
//
//  Created by 王芃 on 2018/10/26.
//  Copyright © 2018 twigcodes. All rights reserved.
//

import UIKit
import CoreImage

extension UIImage {
    public func blur() -> UIImage {
        let radius: CGFloat = 20
        let context = CIContext(options: nil)
        let inputImage = CIImage(cgImage: self.cgImage!)
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue("\(radius)", forKey:kCIInputRadiusKey)
        let result = filter?.value(forKey: kCIOutputImageKey) as! CIImage
        let rect = CGRect(x: radius * 2, y: radius * 2, width: self.size.width * 3 - radius * 4, height: self.size.height * 3 - radius * 4)
        let cgImage = context.createCGImage(result, from: rect)
        let returnImage = UIImage(cgImage: cgImage!)
        
        return returnImage
    }
}
