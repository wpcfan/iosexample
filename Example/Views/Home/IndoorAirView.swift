//
//  IndoorAirView.swift
//  Example
//
//  Created by 王芃 on 2019/2/15.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import Layout
import RxSwift
import RxCocoa

class IndoorAirView: BaseView {
    var indoorAir$ = PublishRelay<IndoorAir>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.loadLayout(
            named: "IndoorAirView.xml",
            state: [
                "location": "indoor.location.name".localized,
                "temperature": "",
                "humidity": "",
                "pm25": "",
                "co2": "",
                "tvoc": ""
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutDidLoad(_ layoutNode: LayoutNode) {
        super.layoutDidLoad(layoutNode)
        
        weak var `self`: IndoorAirView! = self
        indoorAir$.subscribe{ ev in
            guard let indoor = ev.element else { return }
            self.layoutNode?.setState([
                "location": indoor.roomGroup ?? "indoor.location.name".localized,
                "temperature": indoor.temperature != nil ? indoor.temperature!.trunc(length: 4, trailing: "") : "",
                "humidity": indoor.humidity ?? "",
                "pm25": indoor.pm25 ?? "",
                "co2": indoor.co2 ?? "",
                "tvoc": indoor.tvoc ?? ""
                ])
        }
        .disposed(by: self.disposeBag)
    }
}
