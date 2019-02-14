//
//  ChannelView.swift
//  Example
//
//  Created by 王芃 on 2018/10/21.
//  Copyright © 2018年 twigcodes. All rights reserved.
//

import PinLayout
import RxSwift

class HeaderView: UIView {
    
    @objc var bannerView: BannerView!
    @objc var channelView: ChannelView!
    @objc var weatherView: WeatherView!
    @objc var indoorView: IndoorAirView!
    var disposeBag = DisposeBag()
    var bannerTapped = PublishSubject<String>()
    var channelTapped = PublishSubject<String>()
    var banners$ = BehaviorSubject<[Banner]>(value: [])
    var channels$ = BehaviorSubject<[Channel]>(value: [])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bannerView = BannerView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 135))
        channelView = ChannelView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 80))
        weatherView = WeatherView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 50))
        indoorView = IndoorAirView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 50))
        addSubview(bannerView)
        addSubview(channelView)
        addSubview(weatherView)
        addSubview(indoorView)
        self.banners$.subscribe{ ev in
            guard let banners = ev.element else { return }
            self.bannerView.banners = banners
            }
            .disposed(by: self.disposeBag)
        
        self.channels$
            .bind(to: self.channelView.channels$)
            .disposed(by: self.disposeBag)
        
        self.bannerView.rx.bannerImageTap
            .bind(to: self.bannerTapped)
            .disposed(by: self.disposeBag)
        
        self.channelView.rx.channelTap
            .bind(to: self.channelTapped)
            .disposed(by: self.disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        bannerView.pin.top().left().right().height(135)
        channelView.pin.below(of: bannerView, aligned: .left).right().height(80)
        weatherView.pin.below(of: channelView, aligned: .left).right().height(50)
        indoorView.pin.below(of: weatherView).bottom().left().right().height(50)
    }
}
