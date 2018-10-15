//
//  SceneCell.swift
//  Example
//
//  Created by 王芃 on 2018/10/12.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import UIKit

class SceneCell: UITableViewCell {
    
    @IBOutlet weak var imageVIew: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var stackView: UIStackView? {
        didSet {
            self.stackView?.axis = .horizontal
            self.stackView?.spacing = 10
        }
    }
    
    var item: Scene? {
        didSet {
            guard let item = item else {
                return
            }
            imageView?.af_setImage(withURL: URL(string: (item.imageUrl!))!)
            descLabel.text = item.name
        }
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
