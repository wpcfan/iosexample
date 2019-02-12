//
//  DeviceHeaderView.swift
//  Example
//
//  Created by 王芃 on 2019/2/10.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import Foundation

class SectionHeaderView: BaseView {
    let label = UILabel().then {
        $0.font = $0.font.withSize(14)
        $0.text = "我的设备"
    }
    let icon = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = AppIcons.devices
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(icon)
        addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        icon.pin.left(5).top(5).width(24).height(24)
        label.pin.after(of: icon).width(200).height(24).top(5).marginLeft(5)
        sizeToFit()
    }
}
