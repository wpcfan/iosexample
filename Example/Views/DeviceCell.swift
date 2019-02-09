//
//  DeviceCell.swift
//  Example
//
//  Created by 王芃 on 2019/2/8.
//  Copyright © 2019 twigcodes. All rights reserved.
//
import PinLayout

class DeviceCell: BaseTableCell {
    var onlineStatus = true
    let productImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    let deviceNameLabel = UILabel().then {
        $0.textAlignment = .left
        $0.font = $0.font.withSize(14)
    }
    let onlineStatusLabel = UILabel().then {
        $0.textAlignment = .left
        $0.textColor = .primary
        $0.font = $0.font.withSize(12)
    }
    let productTypeLabel = UILabel().then {
        $0.text = "京东智能设备"
        $0.font = $0.font.withSize(12)
        $0.textAlignment = .right
    }
    let rebindButton = UIButton().then {
        $0.setTitle("重新配网", for: .normal)
        $0.titleLabel?.font = $0.titleLabel?.font.withSize(12)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.backgroundColor = .primary
        $0.setTitleColor(.white, for: .normal)
    }
    
    override func initialize() {
        super.initialize()
        
        self.contentView.addSubview(productImage)
        self.contentView.addSubview(deviceNameLabel)
        self.contentView.addSubview(onlineStatusLabel)
        self.contentView.addSubview(productTypeLabel)
        self.contentView.addSubview(rebindButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        productImage.pin
            .left()
            .vCenter()
            .width(70)
            .aspectRatio(1)
        deviceNameLabel.pin
            .after(of: productImage)
            .top(10)
            .width(50%)
            .height(20)
            .marginLeft(5)
        onlineStatusLabel.pin
            .left(to: deviceNameLabel.edge.left)
            .bottom(20)
            .width(100)
            .height(12)
        productTypeLabel.pin
            .after(of: deviceNameLabel, aligned: .top)
            .width(20%)
            .height(20)
        rebindButton.pin
            .below(of: productTypeLabel, aligned: .right)
            .marginTop(10)
            .width(80)
            .height(20)
        rebindButton.isHidden = onlineStatus
    }
}
