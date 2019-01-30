//
//  ChannelView.swift
//  Example
//
//  Created by 王芃 on 2018/10/21.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import Layout
import ReactorKit

class ChannelView: BaseView {
    
    var channels: [Banner] = [
        
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadLayout(
            named: "ChannelView.xml",
            constants: [
                "imageUrls": channels.map{ (channel) -> String in channel.imageUrl! },
                "labels": channels.map{ (channel) -> String in channel.title! }
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChannelView: ReactorKit.View {
    typealias Reactor = ChannelViewReactor
    func bind(reactor: Reactor) {
        
    }
}
