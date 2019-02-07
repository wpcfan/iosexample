//
//  ChannelCell.swift
//  Example
//
//  Created by 王芃 on 2018/10/12.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import UIKit
import ReactorKit
import PinLayout

class ChannelCell: BaseTableCell {
    private var label = UILabel()
    private var button = UIButton()
    
    var channel: Banner? {
        didSet {
            guard let channel = channel else { return }
            initControls(channel: channel)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let imageView = imageView else { return }
        imageView.pin.top(8).center().width(48).height(48)
        label.pin.below(of: imageView, aligned: .center).height(16).marginTop(8)
    }
    
    override func initialize() {
        contentView.addSubview(label)
        contentView.addSubview(button)
    }
    
    private func initControls(channel: Banner) {
        label.text = channel.title
        imageView?.pin_setImage(from: URL(string: channel.imageUrl!))
    }
}
