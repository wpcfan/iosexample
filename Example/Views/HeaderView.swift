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
                
            ]
        }
    }
    
    @IBOutlet var channelView: ChannelView? {
        didSet {
            channelView?.channels = [
                
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
    typealias Reactor = HomeViewControllerReactor
    func bind(reactor: Reactor) {
        
    }
}
