//
//  ChannelCell.swift
//  Example
//
//  Created by 王芃 on 2018/10/12.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import UIKit
import PINRemoteImage
import ReactorKit

class ChannelCell: BaseItemCell, View {
    typealias Reactor = BannerViewReactor
    private var stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 16
        $0.alignment = .fill
        $0.clipsToBounds = true
    }
    
    var channels: [Banner]? {
        didSet {
            guard let channels = channels else { return }
            initControls(channels: channels)
        }
    }
    
    var item: HomeViewModelItem?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
    }
    
    override func initialize() {
        contentView.addSubview(stackView)
    }
    
    func bind(reactor: Reactor) {
        
    }
    
    private func initControls(channels: [Banner]) {
        stackView.removeAllArrangedSubviews()
        channels.forEach { (channel) in
            let label = UILabel().then {
                $0.text = channel.label
            }
            let imageView = UIImageView().then {
                $0.pin_setImage(from: URL(string: channel.imageUrl!))
            }
            let button = UIButton().then {
                $0.addSubview(imageView)
                $0.addSubview(label)
            }
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
            stackView.addArrangedSubview(button)
        }
    }
}
