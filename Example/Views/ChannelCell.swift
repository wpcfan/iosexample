//
//  ChannelCell.swift
//  Example
//
//  Created by 王芃 on 2018/10/12.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import UIKit
import PinLayout

class ChannelCell: BaseCollectionCell {
    var label = UILabel().then {
        $0.textAlignment = .center
        $0.font = $0.font.withSize(14)
    }
    var imageView = UIImageView()
    
    var channel: Channel? {
        didSet {
            guard let channel = channel else { return }
            bindControlValue(channel: channel)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.pin.top().width(50).height(50)
        label.pin.below(of: imageView, aligned: .center).height(14).marginTop(5).width(100%)
    }
    
    override func initialize() {
        contentView.addSubview(label)
        contentView.addSubview(imageView)
    }
    
    private func bindControlValue(channel: Channel) {
        label.text = channel.title
        imageView.pin_setImage(from: URL(string: channel.imageUrl!))
    }
}
