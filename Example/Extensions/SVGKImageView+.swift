//
//  SVGKImageView+.swift
//  Example
//
//  Created by 王芃 on 2019/1/28.
//  Copyright © 2019 twigcodes. All rights reserved.
//
import SVGKit

extension SVGKImageView {
    
    func setTintColor(color: UIColor) {
        if self.image != nil && self.image.caLayerTree != nil {
            changeFillColorRecursively(sublayers: self.image.caLayerTree.sublayers, color: color)
        }
    }
    
    private func changeFillColorRecursively(sublayers: [AnyObject]?, color: UIColor) {
        if let sublayers = sublayers {
            for layer in sublayers {
                if let l = layer as? CAShapeLayer {
                    if l.strokeColor != nil {
                        l.strokeColor = color.cgColor
                    }
                    if l.fillColor != nil {
                        l.fillColor = color.cgColor
                    }
                }
                if let l = layer as? CALayer, let sub = l.sublayers {
                    changeFillColorRecursively(sublayers: sub, color: color)
                }
            }
        }
    }
}
