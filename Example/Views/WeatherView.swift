//
//  AirCell.swift
//  Example
//
//  Created by 王芃 on 2019/2/14.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import Layout
import ReactorKit

class WeatherView: BaseView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.loadLayout(named: "WeatherView.xml",
                        state:["location": "",
                               "temperature": "",
                               "humidity": "",
                               "airQualityIndicator": "",
                               "windForce": "",
                               "windDirection": "",
                               "phenomena": ""])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutDidLoad(_ layoutNode: LayoutNode) {
        super.layoutDidLoad(layoutNode)
        reactor = WeatherViewReactor()
    }
}

extension WeatherView: ReactorKit.StoryboardView {
    typealias Reactor = WeatherViewReactor
    
    func bind(reactor: Reactor) {
        reactor.action.onNext(.load)
        
        reactor.state.map{ state in state.weather }
            .subscribe { ev in
                guard let weather = ev.element else { return }
                self.layoutNode?.setState([
                    "location": weather?.location,
                    "temperature": weather?.temperature,
                    "humidity": weather?.humidity,
                    "airQualityIndicator": weather?.airQualityIndicator,
                    "windForce": weather?.windForce,
                    "windDirection": weather?.windDirection,
                    "phenomena": weather?.phenomena
                    ])
            }
            .disposed(by: self.disposeBag)
    }
}
