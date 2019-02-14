//
//  AirCell.swift
//  Example
//
//  Created by 王芃 on 2019/2/14.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import Layout

class WeatherView: BaseView {
    var weather: Weather? {
        didSet {
            guard let weather = weather, self.layoutNode != nil else {
                return
            }
            self.layoutNode?.setState(["weather": weather])
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.loadLayout(named: "WeatherView.xml", state:["weather": weather])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
