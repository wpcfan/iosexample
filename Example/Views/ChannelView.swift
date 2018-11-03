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
        Banner(id: "1", imageUrl: "https://image.flaticon.com/icons/png/512/138/138281.png", label: "first", link: "http://baidu.com"),
        Banner(id: "1", imageUrl: "https://image.flaticon.com/icons/png/512/148/148982.png", label: "second", link: "http://baidu.com"),
        Banner(id: "1", imageUrl: "https://image.flaticon.com/icons/png/512/1006/1006555.png", label: "third", link: "http://baidu.com"),
        Banner(id: "1", imageUrl: "https://image.flaticon.com/icons/png/512/1087/1087840.png", label: "third", link: "http://baidu.com"),
        Banner(id: "1", imageUrl: "https://image.flaticon.com/icons/png/512/148/148717.png", label: "third", link: "http://baidu.com")
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadLayout(
            named: "ChannelView.xml",
            constants: [
                "imageUrls": channels.map{ (channel) -> String in channel.imageUrl! },
                "labels": channels.map{ (channel) -> String in channel.label! }
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
