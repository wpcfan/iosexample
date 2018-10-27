//
//  ChannelView.swift
//  Example
//
//  Created by 王芃 on 2018/10/21.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import Layout
import ReactorKit

class HeaderView: BaseView {
    
    @IBOutlet var bannerView: BannerView? {
        didSet {
            bannerView?.banners = [
                Banner(id: "1", imageUrl: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080", label: "first", link: "http://baidu.com"),
                Banner(id: "1", imageUrl: "https://images.unsplash.com/photo-1447746249824-4be4e1b76d66?w=1080", label: "second", link: "http://baidu.com"),
                Banner(id: "1", imageUrl: "https://images.unsplash.com/photo-1463595373836-6e0b0a8ee322?w=1080", label: "third", link: "http://baidu.com")
            ]
        }
    }
    
    @IBOutlet var channelView: ChannelView? {
        didSet {
            channelView?.channels = [
                Banner(id: "1", imageUrl: "https://image.flaticon.com/icons/png/512/138/138281.png", label: "first", link: "http://baidu.com"),
                Banner(id: "1", imageUrl: "https://image.flaticon.com/icons/png/512/148/148982.png", label: "second", link: "http://baidu.com"),
                Banner(id: "1", imageUrl: "https://image.flaticon.com/icons/png/512/1006/1006555.png", label: "third", link: "http://baidu.com"),
                Banner(id: "1", imageUrl: "https://image.flaticon.com/icons/png/512/1087/1087840.png", label: "third", link: "http://baidu.com"),
                Banner(id: "1", imageUrl: "https://image.flaticon.com/icons/png/512/148/148717.png", label: "third", link: "http://baidu.com")
            ]
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadLayout(named: "HeaderView.xml")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

extension HeaderView: ReactorKit.View {
    typealias Reactor = HomeViewReactor
    func bind(reactor: Reactor) {
        
    }
}
