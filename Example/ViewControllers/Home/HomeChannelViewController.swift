//
//  ChannelViewController.swift
//  Example
//
//  Created by 王芃 on 2019/1/31.
//  Copyright © 2019 twigcodes. All rights reserved.
//

import PinLayout
import RxSwift

class HomeChannelViewController: BaseViewController, StackContainable {
    
    var channels$ = BehaviorSubject<[Channel]>(value: [])
    var stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillProportionally
        $0.spacing = (UIScreen.main.bounds.width - 2 * 10 - 5 * 50) / 4
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.channels$
            .subscribe{ ev in
            guard let channels = ev.element else { return }
            self.stackView.removeAllArrangedSubviews()
            channels.forEach({ (channel) in
                let imageView = UIImageView().then {
                    $0.pin_setImage(from: URL(string: channel.imageUrl!))
                }
                let label = UILabel().then {
                    $0.text = channel.title
                    $0.textColor = .black
                    $0.textAlignment = .center
                    $0.font = .systemFont(ofSize: 14)
                }
                let view = UIView()
                view.addSubview(imageView)
                view.addSubview(label)
                imageView.pin.top(5).bottom(5).width(50).height(50)
                label.pin.below(of: imageView, aligned: .center).sizeToFit().margin(5, 0, 0)
                self.stackView.addArrangedSubview(view)
            })
            self.view.addSubview(self.stackView)
            self.stackView.pin.all().margin(0, 10, 0)
            self.view.backgroundColor = .white
            self.view.pin.all()
        }
        .disposed(by: self.disposeBag)
    }
    
    public func preferredAppearanceInStack() -> ScrollingStackController.ItemAppearance {
        return .view(height: 80)
    }
}
