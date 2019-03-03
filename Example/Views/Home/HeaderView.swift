//
//  ChannelView.swift
//  Example
//
//  Created by 王芃 on 2018/10/21.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import Layout
import RxSwift
import RxCocoa

class HeaderView: BaseView {
    
    @objc weak var bannerView: BannerView!
    @objc weak var channelView: ChannelView!
    @objc weak var weatherView: WeatherView!
    @objc weak var indoorView: IndoorAirView!
    
    var bannerTapped = PublishRelay<String>()
    var channelTapped = PublishRelay<String>()
    var indoor$ = PublishRelay<IndoorAir>()
    var displayAir$ = PublishRelay<Bool>()
    var homeInfo$ = PublishRelay<HomeInfo>()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.loadLayout(
            named: "HeaderView.xml",
            state: [
                "displayAir": false
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutDidLoad(_ layoutNode: LayoutNode) {
        super.layoutDidLoad(layoutNode)
        
        self.homeInfo$
            .map({ $0.banners })
            .filterNil()
            .subscribe{ ev in
            guard let banners = ev.element else { return }
            self.bannerView.banners = banners
            }
            .disposed(by: self.disposeBag)
        
        self.homeInfo$
            .map({ $0.channels })
            .filterNil()
            .bind(to: self.channelView.channels$)
            .disposed(by: self.disposeBag)
        
        self.indoor$
            .bind(to: self.indoorView.indoorAir$)
            .disposed(by: self.disposeBag)
        
        self.bannerView.rx.bannerImageTap
            .bind(to: self.bannerTapped)
            .disposed(by: self.disposeBag)
        
        self.channelView.rx.channelTap
            .bind(to: self.channelTapped)
            .disposed(by: self.disposeBag)
        
        self.displayAir$
            .bind(to: self.layoutNode!.rx.state("displayAir"))
            .disposed(by: self.disposeBag)
        
    }
}
