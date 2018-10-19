//
//  ChannelCell.swift
//  Example
//
//  Created by 王芃 on 2018/10/12.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import UIKit
import PINRemoteImage

class ChannelCell: UITableViewCell {
    
    @IBOutlet private var stackView: UIStackView? {
        didSet {
            self.stackView?.axis = .horizontal
            self.stackView?.distribution = .fillEqually
            self.stackView?.spacing = 16
            self.stackView?.alignment = .fill
        }
    }
    
    fileprivate var channels: Array<Banner> = []
    
    var item: HomeViewModelItem? {
        didSet {
            guard let item = item as? HomeViewModelChannelItem else {
                return
            }
            stackView?.removeAllArrangedSubviews()
            item.channels.forEach { (channel) in
                let label = UILabel()
                label.text = channel.label
                let imageView = UIImageView()
                imageView.pin_setImage(from: URL(string: channel.imageUrl!))
                let button = UIButton()
                button.addSubview(imageView)
                button.addSubview(label)
//                button.imageView?.pin_setImage(from: URL(string: channel.imageUrl!))
                imageView.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(8)
                    make.centerX.equalToSuperview()
                    make.width.height.equalTo(48)
                }
                label.snp.makeConstraints { make in
                    make.top.equalTo(imageView.snp.bottom).offset(8)
                    make.centerX.equalToSuperview()
                    make.height.equalTo(16)
                }
            stackView?.addArrangedSubview(button)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
