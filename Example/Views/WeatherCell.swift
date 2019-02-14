//
//  AirCell.swift
//  Example
//
//  Created by 王芃 on 2019/2/14.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import PinLayout

class AirCell: BaseCollectionCell {
    var weather: Weather? {
        didSet {
            guard let weather = weather else { return }
            bindControlValue(weather: weather)
        }
    }
    private let locationLabel = UILabel().then {
        $0.textAlignment = .center
    }
    private let tempertureNameLabel = UILabel().then {
        $0.textAlignment = .center
        $0.text = "温度"
        $0.font = $0.font.withSize(12)
    }
    private let tempertureValueLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .primary
        $0.font = $0.font.withSize(12)
    }
    private let humidityNameLabel = UILabel().then {
        $0.textAlignment = .center
        $0.text = "湿度"
        $0.font = $0.font.withSize(12)
    }
    private let humidityValueLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .primary
        $0.font = $0.font.withSize(12)
    }
    private let aqiNameLabel = UILabel().then {
        $0.textAlignment = .center
        $0.text = "空气质量"
        $0.font = $0.font.withSize(12)
    }
    private let aqiValueLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .primary
        $0.font = $0.font.withSize(12)
    }
    private let windNameLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = $0.font.withSize(12)
    }
    private let windValueLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .primary
        $0.font = $0.font.withSize(12)
    }
    private let phonomenaLabel = UILabel().then {
        $0.textAlignment = .center
    }
    
    override func initialize() {
        contentView.addSubview(locationLabel)
        contentView.addSubview(tempertureNameLabel)
        contentView.addSubview(tempertureValueLabel)
        contentView.addSubview(humidityNameLabel)
        contentView.addSubview(humidityValueLabel)
        contentView.addSubview(aqiNameLabel)
        contentView.addSubview(aqiValueLabel)
        contentView.addSubview(windNameLabel)
        contentView.addSubview(windValueLabel)
        contentView.addSubview(phonomenaLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height: CGFloat = 50
        locationLabel.pin.left().top().bottom().width(25%).height(height)
        tempertureValueLabel.pin.after(of: locationLabel, aligned: .top).width(12.5%).height(0.5 * height)
        tempertureNameLabel.pin.below(of: tempertureValueLabel, aligned: .left).width(12.5%).height(0.5 * height)
        humidityValueLabel.pin.after(of: tempertureValueLabel, aligned: .top).width(12.5%).height(0.5 * height)
        humidityNameLabel.pin.below(of: humidityValueLabel, aligned: .left).width(12.5%).height(0.5 * height)
        aqiValueLabel.pin.after(of: humidityValueLabel, aligned: .top).width(12.5%).height(0.5 * height)
        aqiNameLabel.pin.below(of: aqiValueLabel, aligned: .left).width(12.5%).height(0.5 * height)
        windValueLabel.pin.after(of: aqiValueLabel, aligned: .top).width(12.5%).height(0.5 * height)
        windNameLabel.pin.below(of: windValueLabel, aligned: .left).width(12.5%).height(0.5 * height)
        phonomenaLabel.pin.after(of: windValueLabel, aligned: .top).width(25%).height(height)
    }
    
    private func bindControlValue(weather: Weather) {
        locationLabel.text = weather.location
        tempertureValueLabel.text = weather.temperature
        humidityValueLabel.text = weather.humidity
        aqiValueLabel.text = weather.airQualityIndicator
        windValueLabel.text = weather.windForce
        windNameLabel.text = weather.windDirection
        phonomenaLabel.text = weather.phenomena
    }
}
