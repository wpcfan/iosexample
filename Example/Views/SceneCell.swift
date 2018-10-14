//
//  SceneCell.swift
//  Example
//
//  Created by 王芃 on 2018/10/12.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import UIKit

class SceneCell: UITableViewCell {
    
    @IBOutlet weak var stackView: UIStackView? {
        didSet {
            self.stackView?.axis = .horizontal
            self.stackView?.spacing = 10
        }
    }
    
    var item: HomeViewModelItem? {
        didSet {
            guard let item = item as? HomeViewModelSceneItem else {
                return
            }
            
            let scenes = item.scenes
            scenes.forEach { (scene) in
                let imageView = UIImageView()
                imageView.af_setImage(withURL: URL(string: scene.imageUrl!)!)
                let label = UILabel()
                label.text = scene.name
                self.stackView?.addSubview(imageView)
                self.stackView?.addSubview(label)
            }
        }
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
